class AddUserIdToHeartBeats < ActiveRecord::Migration
  def change
    add_column :heart_beats, :user_id, :integer
  end
end
