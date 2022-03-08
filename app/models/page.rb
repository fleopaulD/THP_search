class Page < ApplicationRecord
  has_many :titles
  has_many :subheadings
  has_many :words, through: :titles
end
