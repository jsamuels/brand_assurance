class DateFilter
  attr_internal :location 
  attr_internal :press 
  attr_internal :series
  attr_internal :device
  attr_internal :profile
  attr_internal :patch
  attr_internal :customer
  attr_internal :operator
  attr_internal :pass
  attr_internal :start_date
  attr_internal :end_date
  attr_internal :member_id
  attr_internal :cur_action
  attr_internal :cur_controller
  attr_internal :chart_group # depricated
  attr_internal :chart_type 


  def initialize
    self.location = 'All'
    self.clear!     
  end
  
  def clear!
    # self.location = '' --don't wipe out location (bad things happen)
    self.series = 'All'
    self.press = 'All'
    self.device = nil
    self.profile = 'All'
    self.patch = 'All'
    self.customer = 'All'
    self.operator = 'All'
    self.pass = 'All'
    self.limit = '25'
    # self.chart_type = 'Column3D.swf'
    # self.start_date = ""
    # self.end_date = ""
  end
  
  def limit
    if @limit.blank?
      '25'
    else
      @limit
    end    
  end
  
  def limit=(value)
    @limit = value
  end
  
  def find_locations
    locations = ['All']
    Device.find(:all, :conditions => ["member_id = ? AND active =1 AND location <> '' ", member_id ], :group => "location").each do |device|
      locations << device.location
    end  
    return locations 
  end
        
  def find_presses
    presses = ["All"]
    if location =~ /^All$/i
      my_conditions =   ["member_id = ? AND active =1 AND press <> '' ", member_id ]
    else
      my_conditions =   ["member_id = ? AND active =1 AND press <> '' AND location = ?", member_id, location ] 
    end   
     
    Device.find(:all, :conditions => my_conditions , :group => "press").each do |device|
      presses << device.press
    end    
    return presses
  end      
  
  def find_series
    series = ['All']
    my_conditions = {:member_id => member_id, :active => 1}
    my_conditions[:location] = location unless location =~ /^All$/i

    Device.find(:all, :conditions => my_conditions, :group => "series").each do |device|
      series << device.series
    end  
    return series 
  end
  
  def find_location_devices
    devices = [Device.new({:id => '', :name => 'All'})]
    my_conditions = {:member_id => member_id, :active => 1}
    my_conditions[:location] = location unless location =~ /^All$/i
    my_conditions[:series] = series unless series =~ /^All$/i
    devices += Device.find(:all, :conditions => my_conditions )
  end
  
  def find_search_devices
    if device.blank?
      devices = find_location_devices
      devices.shift # remove All device
    else
      devices = [device]  
    end  
    return devices
  end

  def find_search_profiles
    if profile.blank? || profile =~ /^All$/i
      profiles = find_profiles
      profiles.shift # remove All device
    else
      profiles = [profile]  
    end 
    return profiles
  end

  def find_search_locations
    if location.blank? || location =~ /^All$/i
      locations = find_locations
      locations.shift # remove All location
    else
      locations = [location]  
    end 
    return locations
  end

  def find_search_operators
    if operator.blank? || operator =~ /^All$/i
      operators = find_operators
      operators.shift # remove All operator
    else
      operators = [operator]  
    end 
    return operators
  end

  def device_id
    if device && device.class == Device
      device.id
    else
      0  
    end
  end
  
  def find_profiles
    my_profiles = []
    Proof.find_available_profiles(self).each do |proof|
      my_profiles << proof.profile_name
    end
    return ['All'] + my_profiles
  end
  
  def find_patches
    my_patches = ['All']
    Patch.find_available_patches(self).each do |patch|
      my_patches << patch.patch_name
    end
    return  my_patches
  end
  
  def find_customers
    my_customers = []
    Proof.find_available_customers(self).each do |proof|
      my_customers << proof.customer
    end  
    return ['All'] + my_customers 
  end
  
  def find_operators
    my_operators = ['All']
    Proof.find_available_operators(self).each do |proof|
      my_operators << proof.operator
    end  
    return my_operators
  end
  
  def get_start_date
    get_start_date = start_date.blank? ? (Time.now - 30.days).to_date : start_date.to_date
  end
  
  def get_end_date
    get_end_date = end_date.blank? ? Time.now().to_date : end_date.to_date
    get_end_date += 1
  end  

  def metric
    'dE'
  end
  
  def to_hash
    my_hash = Hash.new
    my_hash["location"] = self.location
    my_hash["device_id"] = self.device_id
    my_hash["device_name"] = self.device.name unless device_id == 0
    my_hash["profile"] = self.profile
    my_hash["customer"] = self.customer
    my_hash["operator"] = self.operator
    my_hash["pass"] = self.pass
    my_hash["start_date"] = self.start_date
    my_hash["end_date"] = self.end_date
    my_hash["chart_type"] = self.chart_type
    return my_hash
  end
   
  def member_pref(pref)
    member = Member.find_by_id(self.member_id)     
    member.pref(pref) || ""
  end           
  

  
private  
    @limit #= '25'
end