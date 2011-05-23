class MemberPreference < ActiveRecord::Base
  belongs_to :member
  validates_uniqueness_of :pref, :scope => :member_id  
  
  # NAMED SCOPES
  named_scope :find_by_pref, lambda { |pref| {:conditions => ['pref = ?', pref ] }  }
end
