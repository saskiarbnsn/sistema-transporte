class AddLitrosToGastos < ActiveRecord::Migration[7.0]
  def change
    add_column :gastos, :litros, :integer
  end
end
