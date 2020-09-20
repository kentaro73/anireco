FactoryBot.define do
  factory :user do
    name { "tester" }
    favorite_anime { "コードギアス" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "tester" }
  end

  # class: User do 忘れない！
  factory :admin_user , class: User do
    name { "admin_user" }
    email { "admin@example.com" }
    admin { true }
    password { "password" }
  end
end
