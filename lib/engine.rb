require "lint"
require "rails"

module MyEngine  
  class Engine < Rails::Engine  
    initializer 'myengine.helper' do |app|  
      ActiveSupport.on_load(:action_view) do
        Rails.logger.warn " ***** lintengine.helper initializer! "
        include Lint::Helper
      end
    end  

    initializer 'myengine.controller' do |app|  
      ActiveSupport.on_load(:action_controller) do 
        Rails.logger.warn " ***** lintengine.controller on_load for action_controller! "

        extend Lint::Controller::ClassMethods
        include Lint::Controller::InstanceMethods
      end
    end
  end
end