module SimpleRole
  module Model
    module ManagedResource
      extend ActiveSupport::Concern

      included do
        has_many :permissions, dependent: :destroy

        validates :class_name, presence: true
        validates :action,     presence: true
      end

      def const
        @_const ||= class_name.try(:safe_constantize)
      end

      def active?
        !const.nil?
      end

      class_methods do
        def reload
          ActiveRecord::Base.transaction do
            clear_cache
            update_managed_resources
            cleanup_managed_resources
            update_permissions
          end
        end

        private

        def update_managed_resources
          manageable_resources.each &method(:find_or_create_by!)
        end

        def cleanup_managed_resources
          (persisted_resources - manageable_resources).each do |condition|
            where(condition).destroy_all
          end
        end

        def update_permissions
          ::Permission.clear_cache
          ::Permission.update_all_from_managed_resources(all)
        end

        def persisted_resources
          all.map(&:attributes).map { |attribute| attribute.slice(*%w(class_name action name)).symbolize_keys }
        end

        def manageable_resources
          @_manageable_resources ||= Resource.build
        end

        def clear_cache
          @_manageable_resources = nil
        end
      end
    end
  end
end
