class Imputation < ApplicationRecord
  validates :imputation, presence: true, uniqueness: true
  has_many :gastos, dependent: :restrict_with_error

  def to_s = imputation
end
