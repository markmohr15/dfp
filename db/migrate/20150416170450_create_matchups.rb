class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :visitor_id
      t.integer :home_id

      t.timestamps null: false
    end
  end
end
