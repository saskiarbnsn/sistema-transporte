class Driver < ApplicationRecord
  validates :name, :address, :city, :province, :phone_number, :cuit, presence: true
end
