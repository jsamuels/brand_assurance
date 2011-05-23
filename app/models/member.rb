class Member < ActiveRecord::Base
  has_many :devices
  has_many :users
  has_many :member_preferences
  accepts_nested_attributes_for :member_preferences, :allow_destroy => true
  
  def pref(pref_name)  
    # return the value of the passed preference for this member
    self.member_preferences.find_by_pref(pref_name)[0][:value]
  end
  
  def after_save
    all_prefs = ["logo", "exp_date", "pass", "warn", "usl", "yAxisMax", "chart_max", "show_box_score", 
                 "location", "series", "device", "pass_fail", "pass_label", "fail_label",  
                 "operator", "profile", "patch", "customer", ]  
    self_prefs = []
    self.member_preferences.each do |pref|  
      self_prefs << pref.pref
    end  
       
    all_prefs.each do |pref_name|
      unless self_prefs.include? pref_name
        my_pref = self.member_preferences.build({:pref => pref_name})
        my_pref.save
      end  
    end   
  end
  
end
