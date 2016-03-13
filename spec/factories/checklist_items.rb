FactoryGirl.define do
  factory :checklist_item do
    sequence(:description) { |n| "Thing to do number #{n}" }
    checked false
  end
end
