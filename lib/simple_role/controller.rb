module SimpleRole
  module ActiveAdmin
    module ResourceController
      extend ActiveSupport::Concern

      included do
        if Rails::VERSION::MAJOR >= 4
          before_action :authorize_access_resource!, except: %i(index new create show edit update destroy)
        else
          before_filter :authorize_access_resource!, except: %i(index new create show edit update destroy)
        end
      end

      private

      def authorize_access_resource!
        authorize_resource!(active_admin_config.resource_class)
      end
    end
  end
end
