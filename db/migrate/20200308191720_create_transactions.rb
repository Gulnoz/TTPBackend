class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :trade
      t.string :ticker
      t.integer :price
      t.belongs_to :user
      t.timestamps
    end
  end
end
