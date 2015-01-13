class AddLastPolled < ActiveRecord::Migration
  def change
    add_column :brains, :last_polled, :timestamp
  end
end
