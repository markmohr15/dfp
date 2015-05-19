class AddDateToMatchup < ActiveRecord::Migration
  def change
    add_column :matchups, :day, :date
  end
end
