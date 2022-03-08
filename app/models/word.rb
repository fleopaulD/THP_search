class Word < ApplicationRecord
  has_many :titles
  has_many :pages, through: :titles

  has_many :subheadings
  has_many :pages, through: :subheadings

  has_many :contents
  has_many :pages, through: :pages

  validates :str, presence: true, uniqueness: true, length: {maximum: 50}    
end
