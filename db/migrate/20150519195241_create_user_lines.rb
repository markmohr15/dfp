class CreateUserLines < ActiveRecord::Migration
  def change
    create_table :user_lines do |t|
      t.integer :matchup_id
      t.integer :user_id
      t.float :visitor_off
      t.float :visitor_def
      t.float :home_off
      t.float :home_def
      t.float :line

      t.timestamps null: false
    end
  end
end
