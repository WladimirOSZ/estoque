# frozen_string_literal: true

class AddUsersToLots < ActiveRecord::Migration[7.0]
  def change
    # add user_id to lots
    add_reference :lots, :created_by, null: false, foreign_key: { to_table: :users }
    add_reference :lots, :approved_by, null: true, foreign_key: { to_table: :users }
  end
end
