# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザー

10.times do |n|
  name  = "【サンプルユーザー】 #{Faker::Name.name}"
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

User.create!(name:  "ゲストユーザー",
             email: "guest@sample.org",
             password:              "password",
             password_confirmation: "password",
             )

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  users.each do |user|
		mysterious_document = Micropost.generate_mysterious_document
		user.microposts.create!(content: mysterious_document)
	end
end

users = User.all
user  = users.last

user.microposts.create!(content: "【制作者より】サンプルユーザーのHomeにようこそ。")
user.microposts.create!(content: "【制作者より】気軽に怪文書を投稿してください。")


# リレーションシップ
users = User.all
user  = users.last
following = users[1..3]
followers = users[3..5]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

