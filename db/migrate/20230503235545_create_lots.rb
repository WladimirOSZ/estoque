# frozen_string_literal: true

class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.integer :mininum_value
      t.integer :mininum_difference

      t.timestamps
    end
  end
end
