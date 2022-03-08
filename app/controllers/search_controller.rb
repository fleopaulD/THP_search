class SearchController < ApplicationController
  def new
  end

  def create
    @user_input = params[:query]
    @word = Word.find_by(str: params[:query])
    @results = @word.pages unless @word.nil?
  end
end
