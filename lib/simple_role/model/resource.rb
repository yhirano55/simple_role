require "set"

module SimpleRole
  module Model
    module Resource
      class << self
        def build
          resource_class.new(config).call
        end

        private

        def resource_class
          config.using_active_admin ? ActiveAdminResource : ActiveRecordResource
        end

        def config
          SimpleRole.config
        end
      end

      class Base
        attr_reader :config

        def initialize(config)
          @config = config
        end

        def call
          raise NotImplementedError, "you must implement #{self.class}::#{__method__}"
        end
      end

      class ActiveAdminResource < Base
        def call
          ::ActiveAdmin.application.namespaces[:admin].resources.inject([]) do |result, resource|
            class_name = resource.controller.resource_class.to_s
            name       = resource.resource_name.name
            actions    = collect_defined_actions(resource)

            result += evaluate_actions(actions).map(&:to_s).sort.map do |action|
              { class_name: class_name, name: name, action: action }
            end
          end
        end

        private

        def collect_defined_actions(resource)
          if resource.respond_to?(:defined_actions)
            defined_actions    = resource.defined_actions
            member_actions     = resource.member_actions.map(&:name)
            collection_actions = resource.collection_actions.map(&:name)
            batch_actions      = resource.batch_actions_enabled? ? [:batch_action] : []

            defined_actions | member_actions | member_actions | collection_actions | batch_actions
          else
            resource.page_actions.map(&:name) | [:index]
          end
        end

        def evaluate_actions(actions)
          actions.inject(Set.new) do |result, action|
            result << (config.actions_dictionary[action] || action)
          end
        end
      end

      class ActiveRecordResource < Base
        attr_reader :active_record_resources

        def initialize(config)
          super
          @active_record_resources = active_record_base_class.subclasses.map(&:to_s)
        end

        def call
          active_record_resources.product(defined_actions).map do |class_name, action|
            { class_name: class_name, action: action }
          end
        end

        private

        def active_record_base_class
          Rails::VERSION::MAJOR >= 5 ? ::ApplicationRecord : ::ActiveRecord::Base
        end

        def defined_actions
          config.actions_dictionary.values.uniq
        end
      end
    end
  end
end
