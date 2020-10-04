FactoryBot.define do
  factory :post do
    title { "鬼滅の刃" }                        # アニメタイトル
    staff { "ufotable" }                        # アニメーション制作
    favorite_scene { "水の呼吸壱ノ型水面斬り" } # 好きなシーン
    broadcast { "2019年春" }                    # 放送日
    cast { "花江夏樹/鬼頭明里" }                # 声優
    episode { 26 }                              # 話数
    association :user
    trait :invalid do 
      title { nil }
    end
  end



  factory :other_post, class: Post do
    title { "氷菓" }
    staff { "京都アニメーション" }
    favorite_scene { "私、気になります" }
    broadcast { "2012年春" }
    cast { "中村悠一/佐藤聡美" }
    episode { 22 }
    association :user
  end
end
