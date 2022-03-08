class Word < ApplicationRecord
  has_many :titles
  has_many :pages, through: :titles

  validates :str, presence: true, uniqueness: true, length: {maximum: 50}    
end
