class Truck < ApplicationRecord
  validates :plate, :brand, :model, :capacity, :fuel, :kilometres, presence: true
end
