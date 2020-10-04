FactoryBot.define do
  factory :user do
    name { "佐藤健" }                                   # 名前
    favorite_anime { "コードギアス" }                   # 好きなアニメ
    sequence(:email) { |n| "sato#{n}@example.com" }
    password { "password" }
  end

  factory :other_user, class: User do
    name { "鈴木ひかる" }
    favorite_anime { "ソードアートオンライン" }
    sequence(:email) { |n| "suzuki#{n}@example.com" }
    password { "password" }
  end

  # class: User do 忘れない！
  factory :admin_user , class: User do
    name { "管理ユーザー" }
    email { "admin@example.com" }
    admin { true }
    password { "password" }
  end
end
