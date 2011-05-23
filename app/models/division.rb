class Division < ActiveRecord::Base
  belongs_to :member 
  has_many :devices
  
  def locations
     my_locations = []
     self.devices.each do |device|
       my_locations << device.location
     end  
     my_locations.compact.uniq
  end
  
end
