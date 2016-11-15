FactoryGirl.define do
  factory :admin_user do
    role { AdminUser.roles.keys.sample.to_sym }
  end
end
