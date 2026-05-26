class Destination < ApplicationRecord
    #belongs_to :trip
    validates :cuit, :name, :location, :city, :province, presence: true
    validates :cuit, uniqueness: true
end
