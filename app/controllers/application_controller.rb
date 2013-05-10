class ApplicationController < ActionController::Base
  protect_from_forgery
  #layout :get_layout

  before_filter :is_xhr

  include ApplicationHelper
  include AppWarden::Mixins::HelperMethods
  include AppWarden::Mixins::ControllerOnlyMethods

  class ClientError               < StandardError; end
  class BadRequestError           < ClientError; end
  class UnauthenticatedError      < ClientError; end
  class UnauthorizedError         < ClientError; end
  class NotFoundError             < ClientError; end
  class TeamNotFoundError         < ClientError; end
  class UserNotFoundError         < ClientError; end
  class SessionNotFoundError      < ClientError; end

  rescue_from BadRequestError,                   :with => :bad_request       # 400 Bad Request
  rescue_from UnauthenticatedError,              :with => :unauthenticated   # 401 Unauthorized
  rescue_from UnauthorizedError,                 :with => :unauthorized      # 403 Forbidden
  rescue_from ActionView::MissingTemplate,       :with => :not_found         # 404 Not Found
  rescue_from NotFoundError,                     :with => :not_found         # 404 Not Found
  rescue_from UserNotFoundError,                 :with => :user_not_found    # 404 Not Found
  rescue_from SessionNotFoundError,              :with => :session_not_found # 404 Not Found
  #rescue_from Mongoid::Errors::DocumentNotFound, :with => :not_found         # 404 Not Found

  # Display error when the request is bad
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def bad_request
    render_error :bad_request, 400, "Requested URI contains invalid characters."
  end

  # Display error when user is unauthenticated to access resource
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def unauthenticated
    flash[:notice] = I18n.t('accounts.unauthenticated')
    render_error :unauthenticated, 401, warden.message || "Could not authenticate you."
  end

  # Display error when user is unauthorized to access resource
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def unauthorized
    flash[:notice] = I18n.t('accounts.unauthorized')
    render_error :unauthorized, 403, "You do not have the correct permissions to access this section."
  end

  # Display error when resource not found
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def not_found(ex)
    @exception = ex.message
    if Rails.env == 'production'
      render_error :not_found, 404, "Resource could not be found."
    else
      render_error :not_found, 404, "Resource could not be found: #{@exception}"
    end
  end

  # Display error when resource not found
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def user_not_found
    render_error :user_not_found, 404, "User not found."
  end

  # Display error when resource not found
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api semipublic
  def session_not_found
    render_error :session_not_found, 404, "Session not found."
  end

  # -- Private Methods --------------------------------------------------

  private

  def get_layout
    request.xhr? ? nil : 'application'
  end

  def is_xhr
    @is_xhr = request.xhr?
  end

  # Authenticate the user
  #
  # @return [nil]
  #   nil if successful
  #
  # @raise [UnauthenticatedError]
  #   raised if the user is not authenticated
  #
  # @api semipublic
  def authenticate!
    authenticate(:user, :basic)

    raise UnauthenticatedError unless current_user
  end

  # Authorizes the user to access resource
  #
  # @return [nil]
  #   nil if successful
  #
  # @raise [UnauthorizedError]
  #   raised if the user is unauthorized
  #
  # @api semipublic
  #
  # def authorize!
  #  raise UnauthorizedError unless current_user
  # end

  # Display error template with http status
  #
  # @return [String, nil]
  #   the content to display
  #
  # @api private
  def render_error(name, status, message, fields = nil)
    Rails.logger.info "+ Rescued from exception: #{name} #{status}"

    #warden.custom_failure! if status == 401

    respond_to do |format|
      format.html { render :template => "errors/#{name}", :status => status }
      format.json do
        if fields
          # Fields is just a JSON string attached to the exception.
          # It lists all the field error messages.
          render :json => {:error => message, :errors => ActiveSupport::JSON.decode(fields)}, :status => status
        else
          render :json => {:error => message}, :status => status
        end
      end
    end
  end

  def beta_tracking
    if authenticated?
      tracking = Tracking.new(:user_id => current_user.id)
      tracking.write_attribute(:controller, controller_name)
      tracking.write_attribute(:action, action_name)
      tracking.write_attribute(:params, santize_params_hash_for_storage(params)) # TMI!
      tracking.write_attribute(:browser, request.env['HTTP_USER_AGENT'])
      tracking.write_attribute(:ip, request.remote_ip)
      tracking.write_attribute(:path, request.fullpath)
      tracking.write_attribute(:host, request.host)
      tracking.save
    end
  end

  def supported_browser
    @unsupported_browser = true

    browserStruct = Struct.new(:browser, :version)
    supportedBrowsers = [
      browserStruct.new("Safari", "5.0.0"),
      browserStruct.new("Chrome", "7.0.0"),
      browserStruct.new("Firefox", "4.0.0"),
      browserStruct.new("Internet Explorer", "8.0"),
      browserStruct.new("Opera", "11.0")
    ]

    user_agent = UserAgent.parse(request.user_agent)
    if supportedBrowsers.detect { |browser| user_agent >= browser }
      @unsupported_browser = false
    end
  end

  def santize_params_hash_for_storage(dirty_params)
    if dirty_params[controller_name.singularize]
      # if the params are for a resource, just store them.
      # Backbone send two sets of params, all in the params and all in the resource key
      return santize_params_hash_for_storage(dirty_params[controller_name.singularize])
    else
      clean_these_keys = [ :controller, :action, :password, :credit_card_number, :credit_card_month, :credit_card_year, :credit_card_cvv ]

      clean_params = dirty_params

      clean_params.each do |k,v|
        if clean_these_keys.include?(k.to_sym)
          clean_params.delete(k)
        end

        if v.is_a?(Hash)
          clean_params[k] = santize_params_hash_for_storage(clean_params[k])
        end
      end

      clean_params
    end
  end

end
