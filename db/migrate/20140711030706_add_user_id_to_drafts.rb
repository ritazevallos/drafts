class AddUserIdToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :user_id, :integer
  end
end
