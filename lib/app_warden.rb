module AppWarden
  module Mixins
    module HelperMethods
      # The main accessor for the warden proxy instance
      # :api: public
      def warden
        request.env['warden']
      end

      # Proxy to the authenticated? method on warden
      # :api: public
      def authenticated?(scope = :default)
        warden.authenticated?(scope)
      end

      # Access the currently logged in user
      # :api: public
      def current_user(scope = :default)
        warden.user(scope)
      end

      def current_user=(user)
        warden.set_user(user)
      end
    end # Helper Methods

    module HelperAppEventMethods
      def authenticated?
        warden.authenticated?
      end

      def current_user
        warden.user
      end
    end

    module ControllerOnlyMethods
      # Logout the current user
      # :api: public
      def logout!(*args)
        warden.raw_session.inspect  # Without this inspect here.  The session does not clear :|
        warden.logout(*args)
      end

      # Proxy to the authenticate method on warden
      # :api: public
      def authenticate(*args)
        warden.authenticate(*args)
      end

      # Proxy to the authenticate method on warden
      # :api: public
      def authenticate!(*args)
        warden.authenticate!(*args)
      end
    end
  end
end
