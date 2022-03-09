class SearchController < ApplicationController
  
  include ApplicationHelper

  def new
  end

  def create
    @user_input = params[:query]
    cleaned_query = cleanup_string(params[:query])
    @results = nil
    
    unless cleaned_query.empty?
      puts "#"*200
      puts "Cleaned query = #{cleaned_query}"
      @word = Word.find_by("str LIKE '%#{cleanup_string(params[:query])}%'")
      @results = @word.pages unless @word.nil?
    end
  end
end
