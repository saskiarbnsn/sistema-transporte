class AddProvinceToDrivers < ActiveRecord::Migration[7.0]
  def change
    add_column :drivers, :province, :string
  end
end
