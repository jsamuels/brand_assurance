class CreateBrandColors < ActiveRecord::Migration
  def self.up
    create_table :brand_colors do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :brand_colors
  end
end
