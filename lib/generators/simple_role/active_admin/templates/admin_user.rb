ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  scope(:all, default: true)

  controller.resource_class.roles.each_key(&method(:scope))

  controller.resource_class.roles.each_key do |role|
    batch_action "assign as #{role}" do |ids|
      formatted_ids = ids - [current_admin_user.id.to_s]
      resource_class.where(id: formatted_ids).update_all(role: resource_class.roles[role])
      redirect_back(fallback_location: admin_root_url, notice: "Selected records have assigned as #{role}")
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
