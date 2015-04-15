class CreatePitchers < ActiveRecord::Migration
  def change
    create_table :pitchers do |t|
      t.string :name
      t.string :team
      t.integer :wins
      t.integer :games
      t.integer :gs
      t.integer :ip
      t.integer :er
      t.integer :so
      t.float :whip

      t.timestamps null: false
    end
  end
end
