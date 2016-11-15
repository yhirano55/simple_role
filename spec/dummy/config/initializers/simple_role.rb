SimpleRole.configure do |config|
  # [Required:Hash]
  # == Role | default: { guest: 0, staff: 1, admin: 2 }
  config.roles = { guest: 0, staff: 1, admin: 2 }

  # [Optional:Array]
  # == Special roles which don't need to manage on database
  config.super_user_roles = [:admin]
  config.guest_user_roles = [:guest]

  # [Optional:String]
  # == User class name | default: 'User'
  config.user_class_name = "AdminUser"

  # [Optional:Symbol]
  # == Default permission | default: :disabled
  # config.default_state = :disabled

  # [Optional:Boolean]
  # == Using Active Admin | default: true
  # config.using_active_admin = true
end
