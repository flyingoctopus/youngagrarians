module Strategies
  class User < Warden::Strategies::Base
    def valid?
      params['email'] && params['password']
    end

    def authenticate!
      user = ::User.where(:email => params['email'].downcase).first

      Rails.logger.info "+ Authenticating user #{params['email']}"

      if user and user.valid_password?(params['password'])
        success!(user)
      else
        fail!("Could not authenticate you.")
      end

      Rails.logger.info "+ Authenticating done"
    end
  end
end

Warden::Strategies.add(:user, Strategies::User)
