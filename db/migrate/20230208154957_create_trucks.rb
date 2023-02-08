class CreateTrucks < ActiveRecord::Migration[7.0]
  def change
    create_table :trucks do |t|
      t.string :plate
      t.string :brand
      t.string :model
      t.float :capacity
      t.string :fuel
      t.float :kilometres

      t.timestamps
    end
  end
end
