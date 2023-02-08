class AddUniqueIndexCustomer < ActiveRecord::Migration[7.0]
  def change
    add_index :customers, :cuit, unique: true
  end
end
