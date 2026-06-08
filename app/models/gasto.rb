class Gasto < ApplicationRecord
  belongs_to :imputation
  belongs_to :driver,  optional: true
  belongs_to :truck,   optional: true

  validates :date, :total, :imputation, presence: true

  before_save  :calculate_breakdown
  after_create  :create_truck_service_if_applicable
  after_update  :sync_truck_service_on_update
  after_destroy :destroy_truck_service_if_applicable

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

  def sync_truck_service_on_update
    relevant = %w[truck_id imputation_id date]
    return unless (saved_changes.keys & relevant).any?

    old_truck_id = saved_changes["truck_id"]&.first      || truck_id
    old_date     = saved_changes["date"]&.first          || date
    old_imp_id   = saved_changes["imputation_id"]&.first || imputation_id
    old_imp_name = Imputation.find_by(id: old_imp_id)&.imputation

    return unless old_imp_name == "Mantenimiento"

    old_truck = Truck.find_by(id: old_truck_id)
    return unless old_truck

    old_service = TruckService.find_by(truck: old_truck, service_date: old_date)
    return unless old_service

    truck_or_imp_changed = saved_changes.key?("truck_id") || saved_changes.key?("imputation_id")

    if truck_or_imp_changed
      # The service never existed for the previous truck/imputación — revert it
      old_service.destroy
    elsif saved_changes.key?("date")
      # Same truck, same Mantenimiento — only sync the date
      old_service.update!(service_date: date)
    end
  end

  def destroy_truck_service_if_applicable
    return unless imputation&.imputation == "Mantenimiento"
    return if truck.nil?

    TruckService.where(truck: truck, service_date: date).destroy_all
  end
end
