module ChartXmlHelper 
 
  def device_quantities_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='#{get_member_pref('device').pluralize}' numberPrefix='' labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' >"
    date_filter.find_search_devices.each do |device|
      link = url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{device.name}' color='3300FF' value='#{device.quantities(date_filter)}' link='#{link}' toolText='#{device.name}' />"
    end
    data += "</chart>"
    data    
  end
  
  def device_de_histogram_xml(date_filter)
    data = "&dataXML=<chart caption='dE Histogram' numberPrefix='' labelDisplay='Rotate' slantLabels='1' >"
    Proof.histogram_de(date_filter).each do |value|
      data += "<set label='#{value.value}' color='3300FF' value='#{value.count}' toolText='#{value.count}' />"
    end  
    data += "</chart>"
  end
  
  def patch_de_xml(date_filter)
    data = "&dataXML=<chart caption='dE by #{get_member_pref('patch')}' numberPrefix='' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    Patch.patch_de(date_filter).each do |patch|
      data += "<set label='#{patch.patch_name}' color='#{patch.hex_color}' value='#{patch.value}' toolText='#{patch.tool_text}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
  end
  
  def device_de_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='#{get_member_pref('device').pluralize}' numberPrefix='' labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    date_filter.find_search_devices.each do |device|
      link = url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{device.name}' color='3300FF' value='#{device.ave_de(date_filter)}' link='#{link}' toolText='#{device.name}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
    data
  end
  
  def profile_de_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='#{get_member_pref('profile').pluralize}' numberPrefix='' labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    date_filter.find_search_profiles.each do |profile|
      link = url_for(:controller => "devices", :action => "trend_de", :profile => profile)
      data += "<set label='#{profile}' color='3300FF' value='#{Proof.profile_ave_de(profile, date_filter)}' link='#{link}' toolText='#{profile}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
    data
  end
  
  def location_de_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='#{get_member_pref('location').pluralize}' numberPrefix='' labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    date_filter.find_search_locations.each do |location|
      link = url_for(:controller => "devices", :action => "trend_de", :location => location)
      data += "<set label='#{location}' color='3300FF' value='#{Proof.location_ave_de(location, date_filter)}' link='#{link}' toolText='#{location}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
    data
  end
  
  def operator_de_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='#{get_member_pref('operator').pluralize}' numberPrefix='' labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    date_filter.find_search_operators.each do |operator|
      link = url_for(:controller => "devices", :action => "trend_de", :operator => operator)
      data += "<set label='#{operator}' color='3300FF' value='#{Proof.operator_ave_de(operator, date_filter)}' link='#{link}' toolText='#{operator}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
    data
  end
  
  def proof_details_xml(proof, date_filter)
    data = "&dataXML=<chart caption='dE by #{get_member_pref('patch')}' numberPrefix='' yAxisMaxValue='#{get_member_pref('yAxisMax')}' >"
    Patch.on_sticker(proof.id).each do |patch|
      data += "<set label='#{patch.patch_name}' color='#{patch.hex_color}' value='#{patch.format_dE2000}' toolText='#{patch.tool_text_patch}' />"
    end
    data += "#{get_trend_zones(date_filter)}</chart>"
  end
  
  def trend_de_xml(date_filter)
    if date_filter.device
      device = date_filter.device
    else
      device = Device.new
      device.name = "Multiple #{get_member_pref('device').pluralize}"  
    end  
    proofs = Proof.filter_proofs(date_filter)    
    if proofs[0] 
      category_xml = "<categories >"
      ave_xml = "<dataSet seriesName='Ave dE' color='000099' anchorBorderColor='000099'>"
      max_xml = "<dataSet seriesName='Max dE' color='990000' anchorBorderColor='990000'>"
      patch_xml = "<dataSet seriesName='#{date_filter.patch} dE' color='009900' anchorBorderColor='009900'>" unless date_filter.patch =~ /^All$/i
      i = 1
      proofs.each do |proof|
        link = url_for(:controller => "devices", :action => "proof_details", :proof => proof.id)
        category_xml += "<category label='#{i}'/>"
        ave_xml += "<set value='#{trend_chart_max(proof.ave_de)}' link='#{link}' toolText='#{proof.ave_de}: #{proof.id}' />" 
        max_xml += "<set value='#{trend_chart_max(proof.max_de)}' link='#{link}' toolText='#{proof.max_de}: #{proof.id}' />" 
        patch_xml += "<set value='#{trend_chart_max(proof.patch_de(date_filter.patch))}' link='#{link}' 
                    toolText='#{proof.patch_de(date_filter.patch)}: #{proof.id}' />" unless date_filter.patch =~ /^All$/i 
        i += 1      
      end
    
      category_xml += "</categories>"
      ave_xml += "</dataSet>" if ave_xml
      max_xml += "</dataSet>" if max_xml
      patch_xml += "</dataSet>" if patch_xml
  
      data = "&dataXML=<chart lineThickness='1' showValues='0' formatNumberScale='0' anchorRadius='2'
                  divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' labelStep='2' 
                  numvdivlines='9' connectNullData='1'
                  caption='#{device.name} ' subcaption='Trend Data' xAxisName='#{proofs[0].proofdate.to_date} to #{proofs[-1].proofdate.to_date}'
                  yAxisName='dE' yAxisMaxValue='#{get_member_pref('yAxisMax')}' > 
                  #{category_xml} #{ave_xml} #{max_xml} #{patch_xml if patch_xml}
                  #{get_trend_zones(date_filter)}
                  </chart>"
    end           
  end
  
  def trend_labch_xml(date_filter, trend)
    # only works at patch level
    patch_name = date_filter.patch
    if patch_name =~ /^All$/i
      return ""
    end  
    if date_filter.device
      device = date_filter.device
    else
      device = Device.new
      device.name = "Multiple #{get_member_pref('device').pluralize}"  
    end  
    proofs = Proof.filter_proofs(date_filter) 

    if proofs[0] 
      category_xml = "<categories >"
      trend_xml = "<dataSet seriesName='#{trend}' color='000099' anchorBorderColor='000099'>"
      proofs.each_with_index do |proof, i|
        link = url_for(:controller => "devices", :action => "proof_details", :proof => proof.id)
        trend_val = proof.trend_dif(patch_name, trend)
        category_xml += "<category label='#{i}'/>"
        trend_xml += "<set value='#{trend_val}' link='#{link}' toolText='#{trend_val}: #{proof.id}' />"    
      end
        category_xml += "</categories>"
        trend_xml += "</dataSet>" if trend_xml

        data = "&dataXML=<chart lineThickness='1' showValues='0' formatNumberScale='0' anchorRadius='2'
                    divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' labelStep='2' 
                    numvdivlines='9' connectNullData='1'
                    caption='#{device.name}' xAxisName='#{proofs[0].proofdate.to_date} to #{proofs[-1].proofdate.to_date}'
                    yAxisName='#{trend}' > 
                    #{category_xml} #{trend_xml}
                    #{get_labch_trend_zones(date_filter)}
                    </chart>"
      end  
    end

  
  def trend_spectral_xml(date_filter) 
    proofs = Proof.filter_proofs(date_filter)
    if proofs[0]
      category_xml = "<categories >"  
      (1..36).each { |i| category_xml += "<category label='#{i}'/>"  }  
      category_xml += "</categories>"  
      proofs_xml = []
      proofs.each do |proof| 
        proof.patches.spectral.each do |patch| #get the spot colors for the selected proofs         
          xml = "<dataSet  color='#{patch.hex_color}'>"  
          link = url_for(:controller => "devices", :action => "proof_details", :proof => proof.id) 
          (1..36).each do |i|
            spectral_key = "spectral_#{i}"    
            xml += "<set value='#{patch.attributes[spectral_key]}' link='#{link}' toolText='#{patch.patch_name}:#{patch.proof_id}' />"
          end
          xml += "</dataSet>" 
          proofs_xml << xml
        end  
      end  
            
      if proofs.first.hersheys? && !(date_filter.patch =~ /^all$/i)         
        target = BrandColor.find(:first, :conditions => {:name => date_filter.patch } )
        if target 
          xml = "<dataSet  color='000000'>"
          target.spectral_targets.each do |value|     
            xml +=  "<set value='#{value}'/>"                        
          end
          xml += "</dataSet>" 
          proofs_xml << xml
        end            
      end   
  
      data = "&dataXML=<chart lineThickness='1' showValues='0' formatNumberScale='0' anchorRadius='2'
                  divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' labelStep='2' 
                  numvdivlines='9' connectNullData='1'
                  caption='Spot Colot Spectral Data' xAxisName='Spectral Values'
                  yAxisName='Value' yAxisMaxValue='1' > 
                  #{category_xml} #{proofs_xml.join("")}
                
                  </chart>"   
   end               
  end

end