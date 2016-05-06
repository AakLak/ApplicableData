class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :email
      t.date :order_date
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
