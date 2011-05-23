class Proof < ActiveRecord::Base
  include NumberFormulas  # mix-in from /lib
  belongs_to :device
  has_many :patches 
  
  # NAMED SCOPES
  named_scope :by_operator, lambda { |operator| {:conditions => ['operator = ?', operator] }  }  
   
  def <=>(other)
    self.created_at <=> other.created_at
  end
  
  #business rules  
  def hersheys?
    # if (167..186).include? self.device_id  #hershey's
    self.device.member_id == 9
  end
  
  def proof_pass?
    if hersheys?
      self.dE2000 > 2.0 ? false : true 
    else  
      self.pass.to_i == 0 ? false : true 
    end
  end
  
  def ave_de_ok?
    if ave_de.to_f < 1.5 
      true
    else
      false
    end  
  end
  
  def max_de_ok?
    if max_de.to_f < 2.5 
      true
    else
      false
    end  
  end
  
  def gray_50_ok?
    if gray_50.to_f < 2.0 
      true
    else
      false
    end  
  end
  
  #instance methods
  def ave_de
    self.dE2000
  end
  
  def max_de
    # NOT including Spot colors
    begin
      max_de = patches.find(:last, :select => "FORMAT(MAX(dE2000),2) as value", :conditions => " is_spot = '0' ", :group => "proof_id").value
    rescue
      max_de = 0.0 
    end
  end
  
  def patch_de(patch_name)
    patch = Patch.find(:last, :conditions => {:proof_id => self.id, :patch_name => patch_name}, :select => "FORMAT(dE2000,2) as value" )
    if patch
      patch.value
    else
      "0.0"
    end    
  end
  
  def gray_50
    # if the patch does not have a value for gray 50% return 0
    begin
      patches.find(:first, :conditions => ["patch REGEXP '050-040-040-000' "], :select => "FORMAT(dE2000,2) as value").value
    rescue
      0.0
    end   
  end
  
  def trend_dif(patch_name, trend)
    @my_patch ||= patches.find(:last, :select => "l-t_l as l_dif, a-t_a as a_dif, b - t_b as b_dif", :conditions => {:patch_name => patch_name})
    if @my_patch
      case trend
      when 'l'
        format_num(@my_patch.l_dif,2)
      when 'a'
        format_num(@my_patch.a_dif,2)
      when 'b'
        format_num(@my_patch.b_dif,2)
      else
        0.0  
      end   
    else
      0.0
    end
  end
    
  
  class << self
   #put class methods here 

   
   def find_available_profiles(date_filter)
     # date_filter.profile = 'All'
     find_available('profile_name', date_filter)
   end
   
   def find_available_customers(date_filter)
     # date_filter.customer = 'All'
     find_available('customer', date_filter)
   end
   
   def find_available_operators(date_filter)
     find_available('operator', date_filter)
   end
   
   def find_available_patches(date_filter)
     # date_filter.patch = 'All'
     find_available('patch_name', date_filter)
   end
   
   def histogram_de(date_filter)
     my_query = "SELECT count(proofs.id) as count, FORMAT(proofs.dE2000,1) as value
                 FROM proofs, devices
                 WHERE proofs.device_id = devices.id
                 AND devices.member_id = #{date_filter.member_id} 
                 AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
     my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i  
     my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
     my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i
     my_query += "AND devices.id = '#{date_filter.device_id}' " unless date_filter.device_id == 0
     my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
     my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i
     my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
     my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
     my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i         
     my_query += "GROUP BY value ORDER BY (FORMAT(dE2000, 1) + 0) "            
     find_by_sql [my_query]
   end
   
   def filter_proofs(date_filter)   
    
     from = "FROM proofs, devices"
     from << ", patches " unless date_filter.patch =~ /^All$/i
     my_query = "SELECT proofs.*
                 #{from}
                 WHERE devices.id = proofs.device_id
                 AND devices.member_id = #{date_filter.member_id}
                 AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
     my_query += "AND proofs.id = patches.proof_id " unless date_filter.patch =~ /^All$/i         
     my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i 
     my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
     my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i             
     my_query += "AND devices.id = #{date_filter.device.id} " unless date_filter.device_id == 0
     my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
     my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i
     my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
     my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$/i
     my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
     my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i           
     my_query += "ORDER BY proofdate DESC, id DESC  LIMIT #{date_filter.limit} "            
     # fail my_query.inspect
     proofs = find_by_sql [my_query]
     # get the last xx entries, but sort them in Acending order
     proofs.reverse!
   end
   
   # chart_xml_helper methoods
   def profile_ave_de(profile, date_filter)
     my_query = "SELECT FORMAT(AVG(proofs.dE2000),2) as value
                 FROM proofs, devices
                 WHERE proofs.profile_name = '#{profile}'
                 AND devices.id = proofs.device_id
                 AND devices.member_id = #{date_filter.member_id} 
                 AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
     my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
     my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i                          
     my_query += "AND devices.id = '#{date_filter.device_id}' " if date_filter.device
     my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
     # my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$/i
     my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
     my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i
     my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i
     my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i            
     my_query += "GROUP BY devices.id "  
     my_values = find_by_sql [my_query]
     if my_values.first
       my_values.first.value
     else
       0.0
     end
   end
   
   def location_ave_de(location, date_filter)
     if date_filter.patch =~ /^All$/i
       location_ave_de_all_patches(location, date_filter)
     else 
       location_ave_de_one_patch(location, date_filter)
     end 
   end
   
   def operator_ave_de(operator, date_filter)
     my_query = "SELECT FORMAT(AVG(proofs.dE2000),2) as value
                 FROM proofs, devices
                 WHERE proofs.operator = '#{operator}'
                 AND devices.id = proofs.device_id
                 AND devices.member_id = #{date_filter.member_id} 
                 AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
     my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
     my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i  
     my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
     my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i                          
     my_query += "AND devices.id = '#{date_filter.device_id}' " if date_filter.device
     my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
     my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i 
     # my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$/i
     my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i             
     my_query += "GROUP BY devices.id "  
     my_values = find_by_sql [my_query]
     if my_values.first
       my_values.first.value
     else
       0.0
     end
   end

  private  
    def find_available(option, date_filter)
      my_query = "SELECT DISTINCT #{option}
                  FROM proofs, devices, patches
                  WHERE proofs.device_id = devices.id
                  AND devices.member_id = #{date_filter.member_id}
                  AND proofs.id = patches.proof_id
                  AND patches.is_spot <> '1' 
                  AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
      my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i 
      my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
      my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i
      my_query += "AND devices.id = '#{date_filter.device_id}' " if date_filter.device && date_filter.device_id != 0
      my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i || option =~ /^operator$/
      my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i || option =~ /^profile_name$/
      my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$|/i || option =~ /^patch_name$/
      my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i || option =~ /^customer$/     
      my_query += "ORDER BY is_spot, #{option} " 
      my_query += "LIMIT 100 "            
      my_values = find_by_sql [my_query]    
      if option =~ /^patch_name$/
        patches = []
        my_values.each do |proof|
          patch = Patch.new
          patch.patch_name = proof.patch_name
          patches << patch
        end    
        
        patches.sort
      else            
        my_values
      end 
    end
  
    def location_ave_de_all_patches(location, date_filter)
      my_query = "SELECT FORMAT(AVG(proofs.dE2000),2) as value
                  FROM proofs, devices
                  WHERE devices.location = '#{location}'
                  AND devices.id = proofs.device_id
                  AND devices.member_id = #{date_filter.member_id} 
                  AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
      my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
      my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i 
      my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i 
      my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i                                    
      my_query += "AND devices.id = '#{date_filter.device_id}' " if date_filter.device
      my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
      my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i
      my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i            
      my_query += "GROUP BY devices.location"   
      # fail my_query.inspect
      my_values = find_by_sql [my_query]
      if my_values.first
        my_values.first.value
      else
        0.0
      end
    end
    
    def location_ave_de_one_patch(location, date_filter)
      # This pulls specific PATCH detail - must have a PATCH value to work
      my_query = "SELECT FORMAT(AVG(patches.dE2000),2) as value
                  FROM proofs, devices, patches
                  WHERE devices.location = '#{location}'
                  AND devices.id = proofs.device_id
                  AND proofs.id = patches.proof_id
                  AND patches.patch_name = '#{date_filter.patch}'
                  AND devices.member_id = #{date_filter.member_id} 
                  AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' " 
      my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
      my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i 
      my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
      my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i                                    
      my_query += "AND devices.id = '#{date_filter.device_id}' " if date_filter.device
      my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
      my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i
      my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i            
      my_query += "GROUP BY devices.location "  
      my_values = find_by_sql [my_query]
      if my_values.first
        my_values.first.value
      else
        0.0
      end
    end
  
  end # class methods   

  
end # proof class
