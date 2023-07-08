class AddStatusToLot < ActiveRecord::Migration[7.0]
  def change
    add_column :lots, :status, :integer, default: 2
  end
end
