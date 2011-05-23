module AnalysisXmlHelper
  
  def location_pass_fail_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='Percent #{get_member_pref('pass_label')} By #{get_member_pref('location')}' numberPrefix=''  labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='100' >"
    date_filter.find_search_locations.each do |location|
      total = Device.device_measurements(date_filter, {:location => location, :pass => 'All' }).to_f
      pass = Device.device_measurements(date_filter, {:location => location, :pass => 'Pass' }).to_f
      if total > 0
        percent = ((pass/total) * 100).round
      else
        percent = 0
      end   
      link = "" # url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{location}' color='3300FF' value='#{percent}' link='#{link}' toolText='#{location}' />"
    end
    data += "</chart>"
    data
  end
  
  def device_pass_fail_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='Percent #{get_member_pref('pass_label')} By #{get_member_pref('device')}' numberPrefix=''  labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='100' >"
    date_filter.find_search_devices.each do |device|
      total = Device.device_measurements(date_filter, {:device => device, :pass => 'All' }).to_f
      pass = Device.device_measurements(date_filter, {:device => device, :pass => 'Pass' }).to_f
      if total > 0
        percent = ((pass/total) * 100).round
      else
        percent = 0
      end
      link = "" # url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{device.name}' color='3300FF' value='#{percent}' link='#{link}' toolText='#{device.name}' />"
    end
    data += "</chart>"
    data
  end
  
  def profile_pass_fail_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='Percent #{get_member_pref('pass_label')} By #{get_member_pref('profile')}' numberPrefix=''  labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='100' >"
    date_filter.find_search_profiles.each do |profile|
      total = Device.device_measurements(date_filter, {:profile => profile, :pass => 'All' }).to_f
      pass = Device.device_measurements(date_filter, {:profile => profile, :pass => 'Pass' }).to_f
      if total > 0
        percent = ((pass/total) * 100).round
      else
        percent = 0
      end
      link = "" # url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{profile}' color='3300FF' value='#{percent}' link='#{link}' toolText='#{profile}' />"
    end
    data += "</chart>"
    data
  end
  
  def operator_pass_fail_xml(date_filter)
    data = "&dataXML=<chart  xAxisName='Percent #{get_member_pref('pass_label')} By #{get_member_pref('operator')}' numberPrefix=''  labelDisplay='Rotate' slantLabels='1' placeValuesInside='1' yAxisMaxValue='100' >"
    date_filter.find_search_operators.each do |operator|
      total = Device.device_measurements(date_filter, {:operator => operator, :pass => 'All' }).to_f
      pass = Device.device_measurements(date_filter, {:operator => operator, :pass => 'Pass' }).to_f
      if total > 0
        percent = ((pass/total) * 100).round
      else
        percent = 0
      end
      link = "" # url_for(:controller => "devices", :action => "trend_de", :device => device.id)
      data += "<set label='#{operator}' color='3300FF' value='#{percent}' link='#{link}' toolText='#{operator}' />"
    end
    data += "</chart>"
    data
  end
end  