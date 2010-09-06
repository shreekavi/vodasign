class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :description
      t.text :summary
      t.date :event_date
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
