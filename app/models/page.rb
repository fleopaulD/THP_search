class Page < ApplicationRecord
  has_many :words, through: :titles

  def save(page)
    new_page = Page.create(url: page.url, signature: page.signature)
    page.words_in_title.each { |word| Title.create(page: new_page, word: word) }
  end
end
