class AddPageviewsTable < ActiveRecord::Migration
  def self.up
    create_table :pageviews, :force => true do |t|
      t.column  :user_id,     :integer              # this is the user's id# from the users table
      t.column  :member_id,   :integer              # this is specific to my code- user's distributor id number
      t.column  :request_url, :string, :limit => 200
      t.column  :pagename,    :string, :limit => 80
      t.column  :session,     :string, :limit => 250
      t.column  :ip_address,  :string, :limit => 16
      t.column  :referer,     :string, :limit => 200
      t.column  :user_agent,  :string, :limit => 200
      t.column  :browser,     :string, :limit => 60 # this is from the Browser model
      t.column  :os,          :string, :limit => 40 #  this is from the Browser model
      t.column  :created_at,  :datetime
    end
  end

  def self.down
    drop_table :pageviews
  end
end