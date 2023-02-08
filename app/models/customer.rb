class Customer < ApplicationRecord
    validates :cuit, :name, presence: true
    validates :cuit, uniqueness: true
    has_many :fields, dependent: :destroy
end
