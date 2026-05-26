class CreateDestinations < ActiveRecord::Migration[7.0]
  def change
    create_table :destinations do |t|
      t.integer :cuit
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
