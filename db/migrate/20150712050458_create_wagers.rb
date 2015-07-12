class CreateWagers < ActiveRecord::Migration
  def change
    create_table :wagers do |t|
      t.integer :user_id
      t.integer :matchup_id
      t.integer :team_id
      t.integer :line

      t.timestamps null: false
    end
  end
end
