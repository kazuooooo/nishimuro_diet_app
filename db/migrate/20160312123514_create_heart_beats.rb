class CreateHeartBeats < ActiveRecord::Migration
  def change
    create_table :heart_beats do |t|
      t.datetime :beat_date_time
      t.integer  :heart_beat
      t.timestamps null: false
    end
  end
end
