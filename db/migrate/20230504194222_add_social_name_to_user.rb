class AddSocialNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :social_name, :string
  end
end
