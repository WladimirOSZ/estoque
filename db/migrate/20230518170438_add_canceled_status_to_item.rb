class AddCanceledStatusToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :item_lots, :canceled, :boolean, default: false
  end
end
