class AddProvinceToDestinations < ActiveRecord::Migration[7.0]
  def change
    add_column :destinations, :province, :string
  end
end
