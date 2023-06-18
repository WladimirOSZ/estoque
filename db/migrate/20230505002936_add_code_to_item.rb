# frozen_string_literal: true

class AddCodeToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :code, :string
  end
end
