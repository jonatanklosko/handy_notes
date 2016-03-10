FactoryGirl.define do
  factory :note do
    association :user, strategy: :build
    title "Title"
    content "There should be some content. Two sentences is pretty enough."
  end
end
