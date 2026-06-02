class Truck < ApplicationRecord
  validates :plate, :brand, :model, :capacity, :fuel, :kilometres, presence: true
  has_many :trips, dependent: :destroy
end
