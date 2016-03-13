FactoryGirl.define do
  factory :checklist do
    association :user, strategy: :create
    title "Title"
    
    factory :checklist_with_items do
      transient do
        items_count 5
      end
      
      after(:create) do |checklist, evaluator|
        create_list(:checklist_item, evaluator.items_count,
                                      checklist: checklist)
      end
    end
  end
end
