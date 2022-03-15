class SearchEngine

  include ApplicationHelper

  def perform(query)
    cleaned_query = cleanup_string(query)
    results = []

    unless cleaned_query.empty?
      words_in_db = cleaned_query.split
                                 .map { |word| Word.where("str LIKE '%#{word}%'")
                                 .includes(titles: :page, subheadings: :page, contents: :page) }
                                 .flatten
      
      words_in_db.each { |word| results << word.titles.map { |a| a.page } }
      words_in_db.each { |word| results << word.subheadings.map { |a| a.page } }
      words_in_db.each { |word| results << word.contents.sort_by(&:occurences).reverse.map { |a| a.page } }  
    end
    
    results.flatten.uniq.delete_if { |page| page.nil? }
  end
end
