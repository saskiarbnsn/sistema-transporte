class Gasto < ApplicationRecord
  belongs_to :imputation
  belongs_to :driver,  optional: true
  belongs_to :truck,   optional: true

  validates :date, :total, :imputation, presence: true

  before_save  :calculate_breakdown
  after_create :create_truck_service_if_applicable

  private

  def calculate_breakdown
    t = total.to_f
    if imputation&.imputation == "Combustible"
      self.gravado = (t * 0.134).round(2)
      self.net     = ((t - gravado) / 1.21).round(2)
      self.iva     = (net * 0.21).round(2)
    else
      self.gravado = 0
      self.net     = (t / 1.21).round(2)
      self.iva     = (t - net).round(2)
    end
  end

  def create_truck_service_if_applicable
    return unless imputation&.imputation == "Mantenimiento"
    return if truck.nil?

    TruckService.create!(
      truck:                 truck,
      service_date:          date,
      kilometres_at_service: truck.service_kilometres,
      notes:                 description
    )
  end
end
