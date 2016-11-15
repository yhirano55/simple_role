ActiveAdmin.register Permission do
  actions :index

  filter :state,
    as: :select,
    collection: controller.resource_class.states

  filter :managed_resource_action_equals, as: :select,
    label: ManagedResource.human_attribute_name(:action),
    collection: -> { ManagedResource.distinct.order(:action).pluck(:action) }

  filter :managed_resource_name_equals, as: :select,
    label: ManagedResource.human_attribute_name(:name),
    collection: -> { ManagedResource.distinct.pluck(:name).sort }

  filter :managed_resource_class_name_equals, as: :select,
    label: ManagedResource.human_attribute_name(:class_name),
    collection: -> { ManagedResource.distinct.order(:class_name).pluck(:class_name) }

  scope(:all, default: true)

  controller.resource_class.manageable_roles.each_key(&method(:scope))

  controller.resource_class.states.each_key do |state|
    batch_action state do |ids|
      resource_class.clear_cache
      resource_class.where(id: ids).update_all(state: resource_class.states[state])
      redirect_back(fallback_location: admin_root_url, notice: "Selected records have changed to #{state}")
    end
  end

  collection_action(:reload, method: :post) do
    ManagedResource.reload
    redirect_back(fallback_location: admin_root_url, notice: "Reloaded")
  end

  action_item(:reload) do
    link_to("Reload", reload_admin_permissions_path, method: :post)
  end

  controller do
    protected

    def scoped_collection
      super.includes(:managed_resource)
    end
  end

  index do
    selectable_column
    column :role
    column(:state) do |record|
      status_tag(record.state, record.enabled? ? :ok : nil)
    end
    column :action
    column :name
    column :class_name
  end
end
