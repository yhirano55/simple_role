FactoryGirl.define do
  factory :permission do
    managed_resource_id 1
    role  { Permission.roles.keys.sample.to_sym }
    state { Permission.states.keys.sample.to_sym }
  end
end
