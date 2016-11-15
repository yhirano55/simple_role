FactoryGirl.define do
  factory :managed_resource do
    class_name "Permission"
    action     "read"
    name       "Permission"
  end
end
