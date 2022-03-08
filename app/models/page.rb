class Page < ApplicationRecord
  has_many :words, through: :titles
end
