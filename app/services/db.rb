class Db
  include ApplicationHelper

  def purge
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
  end

  def save_all_articles(limit=0)
    scraper = Scraper.new
    scraper.login
    return unless scraper.get_articles_urls
    scraper.all_articles_urls.each_with_index do |url, index|

      print "File [#{"%04d" % (index+1)}/#{"%04d" % scraper.all_articles_urls.count}] : "

      content = scraper.get_content(url)

      print "scraped=OK "

      page = Page.create(
        url: content[:url],
        signature: content[:signature],
        title: content[:title]
      )

      print "page=OK "

      cleanup_string(content[:title]).split do |word|
        word_in_db = Word.find_by(str: word)
        word_in_db = Word.create(str: word) if word_in_db.nil?
        Title.create(
          page: page,
          word: word_in_db
        )
      end
      print "title=OK "

      cleanup_string(content[:subheadings]).split.uniq.each do |word|
        word_in_db = Word.find_by(str: word)
        word_in_db = Word.create(str: word) if word_in_db.nil?
        Subheading.create(
          page: page,
          word: word_in_db
        )
      end
      print "subheadings=OK "

      word_counter(content[:contents]).each do |key, value|
        word_in_db = Word.find_by(str: key)
        word_in_db = Word.create(str: key) if word_in_db.nil?
        Content.create(
          page: page,
          word: word_in_db,
          count: value
        )
      end
      puts "contents=OK"

      break if index + 1 >= limit
    end
    puts "Process done."
    scraper.kill
  end

end