module SimpleRole
  module Generators
    module ActiveAdmin
      class ResourceGenerator < Rails::Generators::Base
        source_root File.expand_path("../templates", __FILE__)

        def copy_permission_file
          empty_directory 'app/admin'
          template 'permission.rb', 'app/admin/permission.rb'
        end
      end
    end
  end
end
