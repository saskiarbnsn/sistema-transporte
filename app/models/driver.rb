class Driver < ApplicationRecord
  validates :name, :location, :phone_number, :cuit, presence: true
  has_many :trips, dependent: :destroy
end
