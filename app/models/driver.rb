class Driver < ApplicationRecord
    validates :name, :address, :phone_number, :cuit, presence: true
end
