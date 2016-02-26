FactoryGirl.define do
  factory :user do
    username "sherlockholmes"
    email "sherlock.holmes@gmail.com"
    password_digest User.digest("password")
  end
end