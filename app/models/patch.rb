class Patch < ActiveRecord::Base
  include ColorFormulas  # mix-in from /lib
  include NumberFormulas  # mix-in from /lib
  belongs_to :proof  
  
  # NAMED SCOPES
  named_scope :named, lambda { |name| {:conditions => ['patch_name = ?', name] }  }  
  named_scope :spectral, :conditions => 'is_spot > 0'  
  named_scope :spot, :conditions => 'is_spot > 1'
  named_scope :valid, :conditions => 'is_spot <> 1'     
  
  def <=>(o)  
    my_val = PATCH_SORT_HASH[self.patch_name]
    in_val = PATCH_SORT_HASH[o.patch_name]  
    my_val = 100 unless my_val 
    in_val = 100 unless in_val   
    my_val <=> in_val
  end 
              
  def hex_color
   # from r g b in MySQL this is CONCAT('#', HEX(r), HEX(g), HEX(b)) as my_color
   # ruby wll be something like r.to_s(16) + g.to_s(16) + b.to_s(16)
   "##{self.to_hex(self.red)}#{self.to_hex(self.green)}#{self.to_hex(self.blue)}"
  end
  
  def red
    return self.t_rgb_r if self.t_rgb_r
    #  for records before t_rgb values were put in database
    if self.is_spot == 0 then
      c1 = (self.cyan.to_i) / 100.0
      k1 = (self.black.to_i) / 100.0
      c = ( c1 * ( 1 - k1 ) + k1 )
      r = (( 1 - c ) * 255).to_i
    else
      # the lab_to_rgb is a slow process so I only want to process it once for RG&B
      @rgb ||= Array.new(lab_to_rgb(self.t_l, self.t_a, self.t_b))
      @rgb[0].to_i  
    end
  end
  def green
    return t_rgb_g if t_rgb_g
    #  for records before t_rgb values were put in database
    if self.is_spot == 0 then
      m1 = (self.magenta.to_i) / 100.0
      k1 = (self.black.to_i) / 100.0
      m = ( m1 * ( 1 - k1 ) + k1 )
      g = (( 1 - m ) * 255).to_i
    else
      # the lab_to_rgb is a slow process so I only want to process it once for RG&B
      @rgb ||= Array.new(lab_to_rgb(self.t_l, self.t_a, self.t_b))
      @rgb[1].to_i
    end  
  end
  def blue
    return t_rgb_b if t_rgb_b
    #  for records before t_rgb values were put in database
    if self.is_spot == 0 then
      y1 = (self.yellow.to_i) / 100.0
      k1 = (self.black.to_i) / 100.0
      y = ( y1 * ( 1 - k1 ) + k1 )
      b = (( 1 - y ) * 255).to_i
    else
      # the lab_to_rgb is a slow process so I only want to process it once for RG&B  
      @rgb ||= Array.new(lab_to_rgb(self.t_l, self.t_a, self.t_b))
      @rgb[2].to_i
    end  
  end
  
  def target_l
    format_num(t_l,2)
  end
  def target_a
    format_num(t_a,2)   
  end
  def target_b
    format_num(t_b,2)
  end
  def target_c
    format_num(t_c,2)
  end
  def target_h
    format_num(t_h,2)
  end  
  def format_dE2000
    format_num(dE2000,2)
  end
   
  #  These are not yet being used - 4/13/2010    
  def sample_l
    format_num(l,2)
  end
  def sample_a
    format_num(a,2)   
  end
  def sample_b
    format_num(b,2)
  end   
  def sample_c
    format_num(c,2)
  end
  def sample_h
    format_num(h,2)
  end
  
  def tool_text
    "#{self.patch_name}"
  end  
  
  def tool_text_patch
    tool_text
  end
   
  def cyan
     /^([0-9]{3})-([0-9]{3})-([0-9]{3})-([0-9]{3})/.match(self.patch)
    return $1
  end
  def magenta
     /^([0-9]{3})-([0-9]{3})-([0-9]{3})-([0-9]{3})/.match(self.patch)
    return $2
  end
  def yellow
     /^([0-9]{3})-([0-9]{3})-([0-9]{3})-([0-9]{3})/.match(self.patch)
    return $3
  end    
  def black
     /^([0-9]{3})-([0-9]{3})-([0-9]{3})-([0-9]{3})/.match(self.patch)
    return $4
  end 
 
  def update_rgb
    self.t_rgb_r = self.r
    self.t_rgb_g = self.g
    self.t_rgb_b = self.b
    self.save
  end  
  
  class << self 
    def lab_proof_avg(date_filter)
      my_query = "SELECT patch_name, patch, is_spot, 
                  FORMAT(AVG(t_l),2) as t_l, FORMAT(AVG(t_a),2) as t_a, FORMAT(AVG(t_b),2) as t_b,
                  FORMAT(AVG(t_c),2) as t_c, FORMAT(AVG(t_h),2) as t_h,
                  FORMAT(AVG(l),2) as l, FORMAT(AVG(a),2) as a, FORMAT(AVG(b),2) as b,
                  FORMAT(AVG(c),2) as c, FORMAT(AVG(h),2) as h,
                  FORMAT(AVG(patches.dE2000),2) as dE2000,
                  t_rgb_r, t_rgb_g, t_rgb_b  
                  FROM patches, proofs, devices 
                  WHERE proofs.id = patches.proof_id
                  AND devices.id = proofs.device_id
                  AND is_spot REGEXP '0|2'
                  AND devices.member_id = #{date_filter.member_id} 
                  AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
      my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
      my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i            
      my_query += "AND devices.id = '#{date_filter.device_id}' " unless date_filter.device_id == 0
      my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i 
      my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
      my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i
      my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
      # my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$/i
      my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
      my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i          
      my_query += "GROUP BY patch_name "   
      my_values = find_by_sql [my_query] 
      my_values.sort
    end
    
    
    def patch_de(date_filter)
      my_query = "SELECT patch_name, patch, is_spot, 
                  FORMAT(t_l,2) as t_l, FORMAT(t_a,2) as t_a, FORMAT(t_b,2) as t_b, 
                  FORMAT(AVG(patches.dE2000),2) as value,
                  t_rgb_r, t_rgb_g, t_rgb_b 
                  FROM patches, proofs, devices 
                  WHERE proofs.id = patches.proof_id
                  AND devices.id = proofs.device_id
                  AND is_spot REGEXP '0|2'
                  AND devices.member_id = #{date_filter.member_id} 
                  AND proofs.proofdate BETWEEN '#{date_filter.get_start_date}' AND '#{date_filter.get_end_date}' "
      my_query += "AND proofs.pass = 1 " if date_filter.pass =~ /#{date_filter.member_pref('pass_label')}/i
      my_query += "AND proofs.pass = 0 " if date_filter.pass =~ /#{date_filter.member_pref('fail_label')}/i            
      my_query += "AND devices.id = '#{date_filter.device_id}' " unless date_filter.device_id == 0
      my_query += "AND devices.location = '#{date_filter.location}' " unless date_filter.location =~ /^All$/i
      my_query += "AND devices.press = '#{date_filter.press}' " unless date_filter.press =~ /^All$/i
      my_query += "AND devices.series = '#{date_filter.series}' " unless date_filter.series =~ /^All$/i
      my_query += "AND proofs.profile_name = '#{date_filter.profile}' " unless date_filter.profile =~ /^All$/i
      # my_query += "AND patches.patch_name = '#{date_filter.patch}' " unless date_filter.patch =~ /^All$/i
      my_query += "AND proofs.customer = '#{date_filter.customer}' " unless date_filter.customer =~ /^All$/i
      my_query += "AND proofs.operator = '#{date_filter.operator}' " unless date_filter.operator =~ /^All$/i          
      my_query += "GROUP BY patch, patch_name ORDER BY is_spot, patch, patch_name "   
      my_values = find_by_sql [my_query] 
      my_values.sort 
    end
    
    def on_sticker(proof_id)
      my_query = "SELECT * 
                  FROM patches
                  WHERE proof_id = #{proof_id}
                  AND is_spot REGEXP '[^1]'
                  ORDER BY id "
      my_values = find_by_sql [my_query]    
      my_values.sort        
    end
    
    def find_available_patches(date_filter)
      # right now the other query provides what I need so I just aliased it
      # does not work so good if patch is selected ...
      # Patch.patch_de(date_filter)
      
      # better fit in proofs
      Proof.find_available_patches(date_filter)   
    end
    
    def find_t_rgb_is_null(limit) # This is just to back fill missing data for t_rgb_r[g,b]- created 3/22/2010
      my_query = "SELECT * FROM patches WHERE
                  t_rgb_r IS null
                  LIMIT #{limit}"
      my_values = find_by_sql [my_query]
    end
  
    def find_t_rgb_remaining_to_convert # This is just to back fill missing data for t_rgb_r[g,b]- created 3/22/2010
      my_query = "SELECT count(id) as my_count FROM patches WHERE
                  t_rgb_r IS null"
       my_values = find_by_sql [my_query]
       my_values[0].my_count
    end
  
  end
	
end
