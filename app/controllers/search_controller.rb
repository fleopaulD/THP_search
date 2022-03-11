class SearchController < ApplicationController
  
  include ApplicationHelper

  def new
  end

  def create
    @user_input = params[:query]
    cleaned_query = cleanup_string(params[:query])
    @results = []
    
    unless cleaned_query.empty?
      cleaned_query.split.each do |word|
        @results << Word.where("str LIKE '%#{word}%'").collect {|a| a.titles.collect { |b| b.page }}
      end
      cleaned_query.split.each do |word|
        @results << Word.where("str LIKE '%#{word}%'").collect {|a| a.subheadings.collect { |b| b.page }}
      end
    @results = @results.flatten.uniq.delete_if { |page| page.nil? }
  end
end
