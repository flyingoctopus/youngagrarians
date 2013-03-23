require File.expand_path('../../../lib/strategies/user', __FILE__)
require File.expand_path('../../../lib/strategies/basic', __FILE__)

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.failure_app = lambda { |env| [302, {'Content-Type' => 'text/html; charset=utf-8', 'Location' => '/login'}, ['']] }

  manager.serialize_into_session do |obj|
    {:class => obj.class, :id => obj.id}
  end

  manager.serialize_from_session do |obj|
    begin
      return obj[:class].find(obj[:id])
    rescue Mongoid::Errors::DocumentNotFound => e
      return nil
    end
  end

end
