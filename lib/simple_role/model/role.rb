module SimpleRole
  module Model
    module Role
      extend ActiveSupport::Concern

      included do
        enum role: config.roles
        delegate :super_user_roles, :guest_user_roles, to: :class
        validates :role, presence: true
      end

      def super_user?
        role.in?(super_user_roles)
      end

      def guest_user?
        role.in?(guest_user_roles)
      end

      class_methods do
        def manageable_roles
          @_manageable_roles ||= roles.except(*manageless_roles)
        end

        def super_user_roles
          @_super_user_roles ||= config.super_user_roles.try(:map, &:to_s) || []
        end

        def guest_user_roles
          @_guest_users ||= config.guest_user_roles.try(:map, &:to_s) || []
        end

        private

        def manageless_roles
          (super_user_roles + guest_user_roles).flatten.compact
        end

        def config
          SimpleRole.config
        end
      end
    end
  end
end
