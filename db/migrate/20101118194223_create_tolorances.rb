class CreateTolorances < ActiveRecord::Migration
  def self.up
    create_table :tolorances do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tolorances
  end
end
