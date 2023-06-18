# frozen_string_literal: true

class RenameColmnsInLots < ActiveRecord::Migration[7.0]
  def change
    rename_column :lots, :mininum_value, :minimum_value
    rename_column :lots, :mininum_difference, :minimum_difference
  end
end
