class Customer < ApplicationRecord
    validates :cuit, :name, presence: true
    validates :cuit, uniqueness: true
end
