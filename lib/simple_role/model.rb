require "simple_role/model/managed_resource"
require "simple_role/model/permission"
require "simple_role/model/resource"
require "simple_role/model/role"

module SimpleRole
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def simple_role_user
        send(:include, Role)
      end

      def simple_role_managed_resource
        send(:include, ManagedResource)
      end

      def simple_role_permission
        send(:include, Role)
        send(:include, Permission)
      end
    end
  end
end
