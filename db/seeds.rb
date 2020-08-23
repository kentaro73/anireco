# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: "管理ユーザー",
  email: "k.uneune0703@gmail.com",
admin: true,
password: "pmhkiy",
password_confirmation: "pmhkiy"
)

User.create!(name: "一般ユーザー",
            email: "general@example.com",
            password: "foobaz",
            password_confirmation: "foobaz")

50.times do |n|
name = Faker::Name.name
email = "test-#{n+1}@example.com"
password = "password"
User.create!(name: name,
    email: email,
  password: password,
password_confirmation: password)
end

# Post.create!(title: "名探偵コナン",
#              broadcast: "2020年春",
#              cast: "林原めぐみ",
#              staff: "京都アニメーション",
#              favorite_scene: "そのライフルは飾りですか",
#              media: "TV",
#              episode: "900",
#              watched_at: "2020/6/6")

users = User.order(:created_at).take(6)
10.times do 
# アニメタイトル
title = Faker::Movie.title

# 放送日
season = ["春","夏","秋","冬"]
broadcast = "#{rand(2000..2020)}年#{season[rand(4)]}"

# 声優、制作、お気に入りのシーン
cast = Faker::Name.name
staff = Faker::Company.name
favorite_scene = Faker::Lorem.word


# 話数

episode = rand(10..100)


users.each {|user| user.posts.create!(title: title,
    broadcast: broadcast,
    cast: cast,
    staff: staff,
    favorite_scene: favorite_scene,
    episode: episode) }

end

