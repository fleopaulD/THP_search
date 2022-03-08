class Page < ApplicationRecord
  has_many :titles
  has_many :words, through: :titles
end
