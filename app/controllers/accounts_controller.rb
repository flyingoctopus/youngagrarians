class AccountsController < ApplicationController
  before_filter :authenticate!, :except => [ :login, :login_post, :logout, :new, :create, :forgot_password, :retrieve_password, :password_reset, :reset_password ]

  respond_to :html

  def show
    respond_with @user = current_user
  end

  def new
    if params[:code] && (listee = validate_beta_code(params[:code])) # TODO check if they are approved
      @code = params[:code]
      @user = User.new(:first_name => listee.first_name, :last_name => listee.last_name, :email => listee.email)
      respond_with @user, :layout => 'application'
    else
      @user = User.new
      # SILLY Dynamic stuff...
      [:first_name, :last_name].each do |k|
        # so these dynamic keys will exist for the rails form.
        @user[k] = ''
      end
      render 'accounts/new', :layout => 'application'
    end
  end

  def create
    @code = params[:code]
    if @user = User.create(params[:user])
      if @user.valid?
        self.current_user = @user
        #Notifications.account_created(@user).deliver #TODO: Notifications!
      end
    end

    if @user.valid?
      respond_with @user, :location => :root
    else
      render :action => 'new'
    end
  end

# ACCOUNT UPDATING NOT AVAILABLE. SEE UPDATE_PASSWORD BELOW.
#  def update
#    @user = current_user
#
#    @user.update_attributes(params[:user])
#
#    flash[:notice] = I18n.t('accounts.update_successful')
#    respond_with @user, :location => :account
#  end

  def update_password
    @user = current_user

    old_password = params[:old_password]
    new_password = params[:new_password]

    if old_password == '' or new_password == ''
      flash[:notice] = I18n.t('accounts.password_blank')
    elsif @user.valid_password?(old_password)
      flash[:notice] = I18n.t('accounts.password_wrong')
    else
      @user.update_attributes(:password => new_password)
      flash[:notice] = I18n.t('accounts.password_update_successful')
    end

    respond_with @user, :location => :account
  end

  def forgot_password
    @user = User.new

    if authenticated?
      redirect_to(params[:return_url] || :root)
    end

    render :forgot_password, :layout => 'application'
  end

  def retrieve_password
    @user = User.where(:email => params[:email]).first

    if @user
      Notifications.reset_password(@user).deliver
      render :password_sent, :layout => 'application'
    else
      flash.now[:notice] = t('emails.reset_password.retrieval_failed')
      render :forgot_password, :layout => 'application'
    end
  end

  def password_reset
    @user = User.where(:password_reset_key => params[:code]).first

    if @user
      render :password_reset, :layout => 'application'
    else
      redirect_to :login, :notice => t('passwords.reset_failed')
    end

  end

  def reset_password
    @user = User.where(:password_reset_key => params[:code]).first

    if @user
      if @user.reset_password!(params[:user][:password])
        # log them in!
        self.current_user = @user

        redirect_to :root, :notice => t('passwords.updated')
      else
        flash[:notice] = t('passwords.reset_failed')
        render :password_reset, :layout => 'application'
      end
    else
      redirect_to :login, :notice => t('passwords.reset_failed')
    end
  end

  def login
    if authenticated?
      redirect_to(params[:return_url] || :root)
    else
      render :login, :layout => get_layout
    end
  end

  def login_post
    authenticate(:user)

    if authenticated?
      respond_to do |format|
        format.html do
          redirect_to(params[:return_url] || :root) #, :notice => t('auth.signed_in')
        end
        format.json do
          render :json => { success: 1, user: current_user }
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = t('auth.invalid')
          render :login, :status => 401, :layout => 'application'
        end
        format.json do
          render :json => { success: 0, user: nil, error: I18n.t('accounts.unauthenticated'), warden: warden.message }
        end
      end
    end
  end

  def logout
    logout!
    redirect_to :root, :notice => 'You have been logged out successfully'
  end

  def verify_credentials
    authenticate(:user, :basic)

    raise UnauthenticatedError unless current_user

    render :json => current_user
  end

  def validate_beta_code(code)
    if code == 'acqurate_secret_account_creation_access'
      return MailingList.new(:first_name => '', :last_name => '')
    else
      user_id = code[0, 24]
      encoded_email = code[24, 32]

      if listee = MailingList.where(:id => user_id).first
        if encoded_email == Digest::MD5.hexdigest(listee.email)
          return listee unless listee.deleted
          return false
        end
      end
      return false
    end
  end

end
