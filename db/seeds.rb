# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
  name = Faker::Name.name
  email = "test-#{n+1}@example.com"
  favorite_anime = Faker::Movie.title
  password = "password"
  User.create!(name: name,
    email: email,
    favorite_anime: favorite_anime,
    password: password,
    password_confirmation: password)
  end
  
  User.create!(name: "佐藤健",
    email: "general@example.com",
    favorite_anime: "コードギアス",
    password: "foobaz",
    password_confirmation: "foobaz")
    
  User.create!(name: "管理ユーザー",
    email: "k.uneune0703@gmail.com",
  admin: true,
  password: "pmhkiy",
  password_confirmation: "pmhkiy"
  )

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

Tag.create([  
    { tag_name: "SF"},
    { tag_name: "ファンタジー"},
    { tag_name: "ロボット"},
    { tag_name: "バトル"},
    { tag_name: "ギャグ"},
    { tag_name: "ラブコメ"},
    { tag_name: "日常"},
    { tag_name: "スポーツ"},
    { tag_name: "推理"},
    { tag_name: "戦記"},
    { tag_name: "ミリタリー"},
    { tag_name: "青春"}
])