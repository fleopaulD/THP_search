include ApplicationHelper

puts "Destroying [words] table..."
Word.destroy_all
puts "Destroying [pages] table..."
Page.destroy_all
puts "Destroying [titles] table..."
Title.destroy_all
puts "Destroying [titles] table..."
Subheading.destroy_all
puts "Destroying [contents] table..."
Content.destroy_all
puts ""

json_files = Dir.glob("./db/json/*.json")

json_files.each_with_index do |f, index|
  
  print "File [#{"%04d" % (index+1)}/#{"%04d" % json_files.count}] : #{}"
  
  article = JSON.parse(File.read(f))
  page = Page.create(
    url: article["url"],
    signature: article["signature"],
    title: article["title"]
  )
  cleanup_string(article["title"]).split do |word|
    word_in_db = Word.find_by(str: word)
    word_in_db = Word.create(str: word) if word_in_db.nil?
    Title.create(
      page: page,
      word: word_in_db
    )
  end

  print "title=OK "

  cleanup_string(article["subheadings"]).split.uniq.each do |word|
    word_in_db = Word.find_by(str: word)
    word_in_db = Word.create(str: word) if word_in_db.nil?
    Subheading.create(
      page: page,
      word: word_in_db
    )
  end

  print "subheadings=OK "

  word_counter(article["contents"]).each do |key, value|
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
