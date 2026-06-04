class Destination < ApplicationRecord
  has_many :trips, dependent: :restrict_with_error
  validates :cuit, :name, :location, presence: true
  validates :cuit, uniqueness: true
end
