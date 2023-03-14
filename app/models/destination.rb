class Destination < ApplicationRecord
    #belongs_to :trip
    validates :cuit, :name, :location, presence: true
    validates :cuit, uniqueness: true
end
