FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "sherlockholmes#{n}" }
    sequence(:email) { |n| "sherlock.holmes#{n}@gmail.com" }
    password "password"
    password_confirmation "password"
    activated_at Time.now
  end
  
  factory :invalid_user, parent: :user do
    username nil
  end
end
