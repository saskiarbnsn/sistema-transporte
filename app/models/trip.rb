class Trip < ApplicationRecord
  belongs_to :field
  belongs_to :customer
  belongs_to :destination
  belongs_to :driver
  belongs_to :truck

  has_one_attached :carta_de_porte
  has_one_attached :factura

  validate :date_end_not_before_date

  private

  def date_end_not_before_date
    return unless date && date_end
    errors.add(:date_end, "no puede ser anterior a la fecha de inicio") if date_end < date
  end
end
