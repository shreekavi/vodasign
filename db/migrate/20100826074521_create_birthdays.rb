class CreateBirthdays < ActiveRecord::Migration
  def self.up
    create_table :birthdays do |t|
      t.string :name
      t.string :department
      t.string :designation
      t.string :email
      t.date :date_of_birth

      t.timestamps
    end
  end

  def self.down
    drop_table :birthdays
  end
end
