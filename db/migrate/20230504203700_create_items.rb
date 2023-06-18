# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :photo
      t.integer :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
