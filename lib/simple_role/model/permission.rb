module SimpleRole
  module Model
    module Permission
      extend ActiveSupport::Concern

      included do
        enum state: { disabled: 0, enabled: 1 }

        belongs_to :managed_resource

        delegate :class_name, :action, :name, :const, :active?, to: :managed_resource
        delegate :clear_cache, to: :class

        after_update :clear_cache

        validates :managed_resource, presence: true
        validates :state,            presence: true
        validates :managed_resource_id, uniqueness: { scope: [:role] }
      end

      def ability
        enabled? ? :can : :cannot
      end

      class_methods do
        def update_all_from_managed_resources(managed_resources)
          managed_resources.each do |managed_resource|
            manageable_roles.each_key do |role|
              find_or_create_by!(managed_resource: managed_resource, role: role) do |permission|
                permission.state = default_permission_state
              end
            end
          end
        end

        def indexed_cache
          @_indexed_cache ||= eager_load(:managed_resource).all.group_by(&:role)
        end

        def clear_cache
          @_indexed_cache = nil
        end

        private

        def default_permission_state
          SimpleRole.config.permission_state
        end
      end
    end
  end
end
