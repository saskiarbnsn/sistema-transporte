class Field < ApplicationRecord
  belongs_to :customer
  validates :name, :address, presence: true
end
