# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Word.destroy_all
Page.destroy_all
Title.destroy_all

Dir.glob("./db/json/*.json").each do |f|
  article = JSON.parse(File.read(f))
  page = Page.create(
    url: article["url"],
    signature: article["signature"]
  )
  Parser.new.cleanup_string(article["title"]).split do |word|
    word_in_db = Word.find_by(str: word)
    word_in_db = Word.create(str: word) if word_in_db.nil?
    Title.create(
      page: page,
      word: word_in_db
    )
  end
end