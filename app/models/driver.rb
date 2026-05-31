class Driver < ApplicationRecord
  validates :name, :location, :phone_number, :cuit, presence: true
end
