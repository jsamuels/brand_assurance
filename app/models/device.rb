class Device < ActiveRecord::Base
  belongs_to :member
  belongs_to :division
  has_many :proofs
  
  def last_proof
    self.proofs.last
  end
  
  def ave_de(date_filter)
    Device.device_average_de(self, date_filter)
  end
  
  def quantities(date_filter)
    Device.device_sticker_quantities(date_filter, self)
  end
  
class << self
  #put class methods here  
  def device_average_de(device, date_filter) 
    if date_filter.patch =~ /^All$/i
      # this returns the AVE proof dE
      device_average_de_all_patches(device, date_filter)
    else
      # this returns the average Patch dE
      device_average_de_one_patch(device, date_filter)
    end    
  end

  def device_sticker_quantities(date_filter, device=nil)   
    
    sticker_count = 0
    my_query = "SELECT SUM(proofs.sticker_count) as value
                FROM proofs, devices
                WHERE devices.id = proofs.device_id
                AND devices.member_id = #{date_filter.member_id} 
                AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
    # this allows us to roll through each device in the chart 
    if device
      my_query += "AND devices.id = #{device.id} "
    else             
      my_query += "AND devices.id = #{date_filter.device.id} "  if date_filter.device
    end 
    my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
    my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
    my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i
    my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
    my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
    my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i 
    my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i          
    my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i  
    my_query += "GROUP BY devices.id "
    # fail my_query.inspect
    my_values = find_by_sql [my_query]
    if my_values.first
      my_values.each do |stickers|
        sticker_count += stickers.value.to_i
      end  
    end
    sticker_count   
  end

  def device_measurements(date_filter, *conditions) # count of proofs
    sticker_count = 0
    # Device
    if date_filter.device
      device = date_filter.device
    elsif  conditions[0]  && conditions[0][:device]
      device = conditions[0][:device]
    else
      device = nil
    end    
    # pass
    if conditions[0]  && conditions[0][:pass] 
      pass = conditions[0][:pass]
    else
      pass = date_filter.pass
    end
    # location
    if not date_filter.location =~ /^All$/i
      location = date_filter.location
    elsif  conditions[0]  && conditions[0][:location]
      location = conditions[0][:location]
    else
      location = nil
    end
    # series
    if not date_filter.series =~ /^All$/i
      series = date_filter.series
    elsif  conditions[0]  && conditions[0][:series]
      series = conditions[0][:series]
    else
      series = nil
    end
    # profile
    if not date_filter.profile =~ /^All$/i
      profile = date_filter.profile
    elsif  conditions[0]  && conditions[0][:profile]
      profile = conditions[0][:profile]
    else
      profile = nil
    end
    # operator
    if not date_filter.operator =~ /^All$/i
      operator = date_filter.operator
    elsif  conditions[0]  && conditions[0][:operator]
      operator = conditions[0][:operator]
    else
      operator = nil
    end
    # customer
    if not date_filter.customer =~ /^All$/i
      customer = date_filter.customer
    elsif  conditions[0]  && conditions[0][:customer]
      customer = conditions[0][:customer]
    else
      customer = nil
    end
    my_query = "SELECT COUNT(proofs.id) as value
                FROM proofs, devices
                WHERE devices.id = proofs.device_id
                AND devices.member_id = #{date_filter.member_id} 
                AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
    my_query += "AND devices.id = #{device.id} " if device  
    my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i  
    my_query += "AND devices.series = '#{series}' " if series   
    my_query += "AND devices.location = '#{location}' " if location           
    my_query += "AND proofs.pass = 1 " if pass =~ /^Pass$/i
    my_query += "AND proofs.pass = 0 " if pass =~ /^Fail$/i
    my_query += "AND proofs.profile_name = '#{profile}' " if profile
    my_query += "AND proofs.customer = '#{customer}' " if customer
    my_query += "AND proofs.operator = '#{operator}' " if operator         
    my_query += "GROUP BY devices.id "            
    my_values = find_by_sql [my_query]
    my_values = find_by_sql [my_query]
    if my_values.first
      my_values.each do |stickers|
        sticker_count += stickers.value.to_i
      end  
    end
    sticker_count
  end

  def device_proofs_size(date_filter, device=nil)
    proof_size = 0
    my_query = "SELECT SUM(proofs.proofsize) as value
                FROM proofs, devices
                WHERE devices.id = proofs.device_id
                AND devices.member_id = #{date_filter.member_id} 
                AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
    # this allows us to roll through each device in the chart 
    if device
      my_query += "AND devices.id = #{device.id} "
    else             
      my_query += "AND devices.id = #{date_filter.device.id} "  if date_filter.device
    end  
    my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i  
    my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
    my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i
    my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
    my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
    my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i 
    my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i          
    my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i  
    my_query += "GROUP BY devices.id "
    # fail my_query.inspect
    my_values = find_by_sql [my_query]
    if my_values.first
      my_values.each do |inches|
        proof_size += inches.value.to_i
      end  
    end
    proof_size 
  end

  def get_device_or_nil(id)
    if id == '' then
      return nil
    else
      find(id)
    end    
  end

private
  def device_average_de_all_patches(device, date_filter)
    # because this is by device it does not need member_id
    from = "FROM proofs, devices"
    from << ", patches " unless date_filter.patch =~ /^All$/i
    my_query = "SELECT FORMAT(AVG(proofs.dE2000),2) as value
                FROM proofs, devices
                WHERE devices.id = #{device.id}
                AND devices.id = proofs.device_id
                AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
    my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i        
    my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i  
    my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i                           
    my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
    my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
    my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i           
    my_query += "GROUP BY devices.id "            
    my_values = find_by_sql [my_query]
    if my_values.first
      my_values.first.value
    else
      0.0
    end
  end
  
  def device_average_de_one_patch(device, date_filter)
    # because this is by device it does not need member_id
    # patch detail is hard coded into this query

    my_query = "SELECT FORMAT(AVG(patches.dE2000),2) as value
                FROM proofs, devices, patches
                WHERE devices.id = #{device.id}
                AND devices.id = proofs.device_id
                AND proofs.id = patches.proof_id
                AND patches.patch_name = '#{date_filter.patch}'
                AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
    my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
    my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i   
    my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i                          
    my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
    my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
    my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i           
    my_query += "GROUP BY devices.id "            
    my_values = find_by_sql [my_query]
    if my_values.first
      my_values.first.value
    else
      0.0
    end
  end

end
  
end
