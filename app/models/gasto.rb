class Gasto < ApplicationRecord
  belongs_to :imputation
  belongs_to :driver,  optional: true
  belongs_to :truck,   optional: true

  validates :date, :total, :imputation, presence: true

  before_save :calculate_breakdown

  private

  def calculate_breakdown
    t = total.to_f
    self.gravado = (t / 1.21).round(2)
    self.iva     = (t - gravado).round(2)
    self.net     = gravado
  end
end
