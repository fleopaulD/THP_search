class SearchController < ApplicationController
  
  def new
    return unless params[:token] == ENV["API_USER_TOKEN"]
    @user_input = params[:query]
    @results = SearchEngine.new.perform(params[:query])
    render json: valid_response
  end

  private

  def valid_response
    response = Hash.new
    response["query"] = @user_input
    response["results"] = []
    
    @results.each do |result|
      response["results"] << {result.title => result.url}
    end
    response
  end
end
