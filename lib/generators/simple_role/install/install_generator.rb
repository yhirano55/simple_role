require 'rails/generators/migration'
require 'generators/simple_role/install/helpers'

module SimpleRole
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include SimpleRole::Generators::Helpers

      source_root File.expand_path("../templates", __FILE__)

      class_option :model, optional: true, type: :string, banner: "model",
                   desc: "Specify the model class name if you will use anything other than `User`"

      def copy_initializer_file
        template "initializer.rb", "config/initializers/simple_role.rb"
      end

      def configure_model
        generate "model #{model_class_name} --skip-migration"
        inject_simple_role_to_model
      end

      def inject_simple_role_to_model
        indents = "  " * (namespaced? ? 2 : 1)
        inject_into_class(model_path, model_class_name, "#{indents}simple_role_user\n")
      end

      def configure_managed_resource_model
        generate "model #{managed_resource_class_name} --skip-migration"
        inject_simple_role_to_managed_resource_model
      end

      def inject_simple_role_to_managed_resource_model
        inject_into_class(managed_resource_model_path, managed_resource_class_name, "  simple_role_managed_resource\n")
      end

      def configure_permission_model
        generate "model #{permission_class_name} --skip-migration"
        inject_simple_role_to_permission_model
      end

      def inject_simple_role_to_permission_model
        inject_into_class(permission_model_path, permission_class_name, "  simple_role_permission\n")
      end

      def copy_migration_files
        if model_class_name.safe_constantize.nil?
          migration_template "migration/create_table_users.rb", "db/migrate/create_table_users.rb", migration_class_name: migration_class_name
        else
          migration_template "migration/add_role_to_users.rb", "db/migrate/add_role_to_users.rb", migration_class_name: migration_class_name
        end

        migration_template "migration/create_table_managed_resources.rb", "db/migrate/create_table_managed_resources.rb", migration_class_name: migration_class_name
        migration_template "migration/create_table_permissions.rb", "db/migrate/create_table_permissions.rb", migration_class_name: migration_class_name
      end

      # Define the next_migration_number method (necessary for the migration_template method to work)
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          sleep 1 # make sure each time we get a different timestamp
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      private

      def migration_class_name
        if Rails::VERSION::MAJOR >= 5
          "ActiveRecord::Migration[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        else
          "ActiveRecord::Migration"
        end
      end
    end
  end
end
