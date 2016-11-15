module SimpleRole
  module Generators
    module Cancan
      class AbilityGenerator < Rails::Generators::Base
        source_root File.expand_path("../templates", __FILE__)

        def copy_ability_file
          template "ability.rb", "app/models/ability.rb"
        end

        private

        def user_class_name
          SimpleRole.config.user_class_name
        end

        def using_active_admin?
          SimpleRole.config.using_active_admin
        end
      end
    end
  end
end
