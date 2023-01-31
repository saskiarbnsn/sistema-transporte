class CreateDrivers < ActiveRecord::Migration[7.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.date :birth_date
      t.string :phone_number
      t.string :address
      t.string :cuit

      t.timestamps
    end
  end
end
