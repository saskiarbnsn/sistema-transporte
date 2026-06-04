class Truck < ApplicationRecord
  validates :plate, :brand, :model, :capacity, :fuel, :kilometres, presence: true
  validate :km_service_less_than_km
  has_many :trips, dependent: :destroy
  has_many :truck_services, dependent: :destroy

  def service_kilometres_restart
    last_svc = truck_services.first
    start_date = last_svc&.service_date
    q = trips.where.not(kilometres: nil)
    q = q.where("date >= ?", start_date) if start_date
    q.sum(:kilometres).to_f
  end

  def km_service_less_than_km
    if service_kilometres > kilometres.to_f
      errors.add(:service_kilometres, "no puede ser mayor que los kilómetros actuales del camión.")
    end
  end
end
