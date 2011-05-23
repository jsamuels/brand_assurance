class UserPreference < ActiveRecord::Base
  belongs_to :user
   validates_uniqueness_of :pref, :scope => :user_id   
end
