class CreateItemLots < ActiveRecord::Migration[7.0]
  def change
    create_table :item_lots do |t|
      t.references :item, null: false, foreign_key: true
      t.references :lot, null: false, foreign_key: true
      t.timestamps
    end
  end
end
