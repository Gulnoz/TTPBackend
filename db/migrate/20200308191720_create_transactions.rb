class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :trade, :default => 'Buy'
      t.string :ticker
      t.integer :qty
      t.decimal :price, precision: 10, scale: 2 
      t.belongs_to :user
      t.timestamps
    end
  end
end
