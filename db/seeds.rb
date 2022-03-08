# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Word.destroy_all
Page.destroy_all

1000.times do
  Word.create(
    str: Faker::Lorem.word
  )
end

300.times do
  Page.create(
    url: Faker::Internet.url(host: 'thehackingproject.org'),
    signature: Faker::Internet.password
  )
end