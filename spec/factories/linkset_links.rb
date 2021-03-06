FactoryGirl.define do
  factory :linkset_link do
    association :linkset
    sequence(:name) { |n| "Link-#{n}" }
    url "example.com"
    sequence(:description) { |n| "Description for link-#{n}" }
  end
end
