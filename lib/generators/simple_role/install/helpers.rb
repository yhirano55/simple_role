module SimpleRole
  module Generators
    module Helpers
      private

      def model_class_name
        options[:model] ? options[:model].classify : "User"
      end

      def model_file_path
        model_name.underscore
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{model_file_path}.rb")
      end

      def managed_resource_class_name
        "ManagedResource"
      end

      def managed_resource_file_path
        managed_resource_class_name.underscore
      end

      def managed_resource_model_path
        @managed_resource_model_path ||= File.join("app", "models", "#{managed_resource_file_path}.rb")
      end

      def permission_class_name
        "Permission"
      end

      def permission_file_path
        permission_class_name.underscore
      end

      def permission_model_path
        @permission_model_path ||= File.join("app", "models", "#{permission_file_path}.rb")
      end

      def namespace
        Rails::Generators.namespace if Rails::Generators.respond_to?(:namespace)
      end

      def namespaced?
        !!namespace
      end

      def model_name
        if namespaced?
          [namespace.to_s] + [model_class_name]
        else
          [model_class_name]
        end.join("::")
      end
    end
  end
end
