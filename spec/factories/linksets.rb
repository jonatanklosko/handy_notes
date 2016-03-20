FactoryGirl.define do
  factory :linkset do
    association :user, strategy: :create
    title "Example links"
    
    factory :linkset_with_links do
      transient do
        links_count 5
      end
      
      after(:create) do |linkset, evaluator|
        create_list(:linkset_link, evaluator.links_count,
                                      linkset: linkset)
      end
    end
  end
end
