FactoryBot.define do
  factory :post do
    title { "test title" }
    staff { "test staff" }
    favorite_scene { "test favorite_anime" }
    broadcast { "test broadcast" }
    cast { "test cast" }
    episode { 13 }
    association :user
    trait :invalid do
      title { nil }
    end
  end



  factory :other_post, class: Post do
    title { "other title" }
    staff { "other staff" }
    favorite_scene { "other favorite_anime" }
    broadcast { "other broadcast" }
    cast { "other cast" }
    episode { 26 }
    association :user

  end
end
