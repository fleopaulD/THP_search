class Page < ApplicationRecord
  has_many :titles
  has_many :subheadings
  has_many :contents

  private

  def self.check_updates
    updates = {new_pages: [], removed_pages: [], modified_pages: []}
    urls_in_db = Page.all.map(&:url)

    scraper = Scraper.new
    scraper.login
    scraper.get_articles_urls

    moves = (urls_in_db + scraper.all_articles_urls).uniq

    moves.each do |move|
      updates[:new_pages] << move unless urls_in_db.any?(move)
      updates[:removed_pages] << move unless scraper.all_articles_urls.any?(move)
    end

    Page.all.each do |page|
      next if updates[:removed_pages].any?(page.url)
      content = scraper.get_content(page.url)
      updates[:modified_pages] << page.url unless page.signature == content[:signature]
    end

    scraper.kill
    updates
  end
  
end
