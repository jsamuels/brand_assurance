class CreateTolerances < ActiveRecord::Migration
  def self.up
    create_table :tolerances do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tolerances
  end
end
