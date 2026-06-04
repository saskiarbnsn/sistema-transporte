class Truck < ApplicationRecord
  validates :plate, :brand, :model, :capacity, :fuel, :kilometres, presence: true
  has_many :trips, dependent: :destroy
  has_many :truck_services, dependent: :destroy

  def service_kilometres
    last_svc = truck_services.first
    start_date = last_svc&.service_date
    q = trips.where.not(kilometres: nil)
    q = q.where("date >= ?", start_date) if start_date
    q.sum(:kilometres).to_f
  end
end
