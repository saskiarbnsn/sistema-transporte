class CreateTruckServices < ActiveRecord::Migration[7.0]
  def change
    create_table :truck_services do |t|
      t.references :truck, null: false, foreign_key: true
      t.date :service_date
      t.float :kilometres_at_service
      t.string :notes

      t.timestamps
    end
  end
end
