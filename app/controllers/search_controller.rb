class SearchController < ApplicationController
  
  include ApplicationHelper

  def new
  end

  def create
    return unless params[:token] == ENV["API_USER_TOKEN"]

    @user_input = params[:query]
    cleaned_query = cleanup_string(params[:query])
    @results = []
    
    unless cleaned_query.empty?
      words_in_query = cleaned_query.split
      words_in_db = words_in_query.map { |word| Word.where("str LIKE '%#{word}%'") }.flatten

      words_in_db.each do |word|
        @results << word.titles.map { |a| a.page }
      end
      words_in_db.each do |word|
        @results << word.subheadings.map { |a| a.page }
      end
      words_in_db.each do |word|
        @results << word.contents.sort_by(&:occurences).reverse.map { |a| a.page }
      end

    @results = @results.flatten.uniq.delete_if { |page| page.nil? }
    end

    response = {}
    response["query"] = @user_input
    response["results"] = []
    @results.each do |result|
      response["results"] << {result.title => result.url}
    end
    render json: response
  end
end
