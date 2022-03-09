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
Subheading.destroy_all
Content.destroy_all

json_files = Dir.glob("./db/json/*.json")

json_files.each_with_index do |f, index|
  
  print "File [#{"%04d" % (index+1)}/#{"%04d" % json_files.count}] : #{}"
  
  article = JSON.parse(File.read(f))
  page = Page.create(
    url: article["url"],
    signature: article["signature"],
    title: article["title"]
  )
  Parser.new.cleanup_string(article["title"]).split do |word|
    word_in_db = Word.find_by(str: word)
    word_in_db = Word.create(str: word) if word_in_db.nil?
    Title.create(
      page: page,
      word: word_in_db
    )
  end

  print "title=OK "

  Parser.new.cleanup_string(article["subheadings"]).split.uniq.each do |word|
    word_in_db = Word.find_by(str: word)
    word_in_db = Word.create(str: word) if word_in_db.nil?
    Subheading.create(
      page: page,
      word: word_in_db
    )
  end

  print "subheadings=OK "

  Parser.new.word_counter(article["contents"]).each do |key, value|
    word_in_db = Word.find_by(str: key)
    word_in_db = Word.create(str: key) if word_in_db.nil?
    Content.create(
      page: page,
      word: word_in_db,
      count: value
    )
  end
  
  puts "contents=OK"

end
