class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= <%= user_class_name %>.new

    if user.super_user?
      can(:manage, :all)
    else
      register_can_or_cannot_from_permissions(user)
    end
<%- if using_active_admin? -%>

    # NOTE: Everyone can read the page of Permission Deny
    can(:read, ActiveAdmin::Page, name: "Dashboard")
<%- end -%>
  end

  private

  def register_can_or_cannot_from_permissions(user)
    return if user.guest_user?

    (::Permission.indexed_cache[user.role] || []).select(&:active?).each do |permission|
<%- if using_active_admin? -%>
      if permission.class_name == "ActiveAdmin::Page"
        send(permission.ability, permission.action.to_sym, permission.const, { name: permission.name })
      else
        send(permission.ability, permission.action.to_sym, permission.const)
      end
<%- else -%>
      send(permission.ability, permission.action.to_sym, permission.const)
<%- end -%>
    end
  end
end
