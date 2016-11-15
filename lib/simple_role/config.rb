require "ostruct"

module SimpleRole
  class Config
    attr_reader :actions_dictionary
    attr_accessor :roles, :super_user_roles, :guest_user_roles, :user_class_name, :default_state, :using_active_admin

    def initialize
      @roles              = { guest: 0, staff: 1, admin: 2 }
      @guest_user_roles   = []
      @super_user_roles   = []
      @user_class_name    = "User"
      @default_state      = :disabled
      @using_active_admin = true
      @actions_dictionary = OpenStruct.new(
        index:   :read,
        show:    :read,
        new:     :create,
        create:  :create,
        edit:    :update,
        update:  :update,
        destroy: :destroy,
      ).freeze
    end

    def permission_state
      default_state.to_s == "enabled" ? :enabled : :disabled
    end
  end
end
