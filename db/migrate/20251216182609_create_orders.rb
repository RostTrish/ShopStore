class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2

      t.integer :payment_method, default: 0, null: false
      t.integer :delivery_method, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
