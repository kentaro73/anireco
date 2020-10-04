FactoryBot.define do
  factory :comment do
    content { "1コメ" }
    association :user
    association :post
  end
end
