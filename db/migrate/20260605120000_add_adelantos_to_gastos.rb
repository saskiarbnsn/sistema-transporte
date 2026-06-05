class AddAdelantosToGastos < ActiveRecord::Migration[7.0]
  def change
    add_column :gastos, :adelantos, :string
  end
end
