# frozen_string_literal: true

class ChangeDateToDatetimeLots < ActiveRecord::Migration[7.0]
  def change
    change_column :lots, :start_date, :datetime
    change_column :lots, :end_date, :datetime
  end
end
