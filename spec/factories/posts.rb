FactoryBot.define do
  factory :post do
    title { "test title" }
    staff { "test staff" }
    favorite_scene { "test favorite_anime" }
    broadcast { "test broadcast" }
    cast { "test cast" }
    episode { 13 }
    association :user
  end
end
