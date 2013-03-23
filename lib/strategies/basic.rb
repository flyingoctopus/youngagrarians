module Strategies
  class Basic < Warden::Strategies::Base
    def valid?
      params = request.env['action_dispatch.request.path_parameters']

      if params
        @auth ||= Rack::Auth::Basic::Request.new(request.env)

        @auth.provided? && @auth.basic? && @auth.credentials
      end
    end

    def authenticate!
      email    = @auth.credentials[0]
      password = @auth.credentials[1]

      Rails.logger.info "+ Authenticating user (basic) #{email}"

      user = ::User.where(:email => email.downcase).first

      if user && user.valid_password?(password)
        success!(user)
      else
        fail!("Could not authenticate you.")
      end

      Rails.logger.info "+ Authenticating done"
    end
  end
end

Warden::Strategies.add(:basic, Strategies::Basic)
