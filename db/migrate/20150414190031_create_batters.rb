class CreateBatters < ActiveRecord::Migration
  def change
    create_table :batters do |t|
      t.string :name
      t.string :team
      t.text :position
      t.integer :pa
      t.integer :ab
      t.integer :hits
      t.integer :doubles
      t.integer :triples
      t.integer :homers
      t.integer :runs
      t.integer :rbis
      t.integer :walks
      t.integer :hbps
      t.integer :sb
      t.integer :cs

      t.timestamps null: false
    end
  end
end
