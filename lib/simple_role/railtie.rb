require "rails"

module SimpleRole
  class Railtie < ::Rails::Railtie
    initializer "simple_role" do
      ActiveSupport.on_load(:active_record) do
        require "simple_role/model"
        ::ActiveRecord::Base.send(:include, SimpleRole::Model)
      end

      if defined?(ActiveAdmin) && SimpleRole.config.using_active_admin
        ActiveSupport.on_load(:after_initialize) do
          require "simple_role/controller"
          ::ActiveAdmin::ResourceController.send(:include, SimpleRole::ActiveAdmin::ResourceController)
        end
      end
    end
  end
end
