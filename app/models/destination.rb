class Destination < ApplicationRecord
  validates :cuit, :name, :location, presence: true
  validates :cuit, uniqueness: true
end
