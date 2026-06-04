class Trip < ApplicationRecord
  belongs_to :field
  belongs_to :customer
  belongs_to :destination
  belongs_to :driver
  belongs_to :truck

  has_one_attached :factura
  has_one_attached :carta_de_porte

  scope :active_today, -> {
    where("date <= ? AND (date_end IS NULL OR date_end >= ?)", Date.current, Date.current)
  }

  validate :date_end_not_before_date
  before_save :calculate_net

  private

  def date_end_not_before_date
    return unless date && date_end
    errors.add(:date_end, "no puede ser anterior a la fecha de inicio") if date_end < date
  end

  def calculate_net
    return unless tariff && weight
    self.net       = (tariff * weight / 1000.0).round(2)
    self.importeiva = (self.net * 1.21).round(2)
  end
end
