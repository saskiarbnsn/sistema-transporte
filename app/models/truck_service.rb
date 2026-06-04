class TruckService < ApplicationRecord
  belongs_to :truck
  validates :service_date, presence: true
  default_scope { order(service_date: :desc) }
end
