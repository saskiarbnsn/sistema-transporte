class AddCityToDrivers < ActiveRecord::Migration[7.0]
  def change
    add_column :drivers, :city, :string
  end
end
