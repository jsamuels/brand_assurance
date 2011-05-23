require 'rexml/document'

module ChartHelper
  def chart_width
    590
  end
  def chart_height(chart_xml=nil)
    case controller.action_name
      when "trend_labch"
        225   
      when /patch_de|proof_details/
        xml = REXML::Document.new(chart_xml)
        count = 100
        xml.elements.each("//set label") do |x|
          count += 11
        end
        count 
      else
        650 
      end  
  end
  def chart_swf(chart_type)
    chart_type
  end
  
  def xml_data(date_filter, trend=false)
      case controller.action_name
      # TRENDS TAB
      when "trend_de"
        trend_de_xml(date_filter) 
      when "trend_labch"
        trend_labch_xml(date_filter, trend)
      when "trend_spectral"
        trend_spectral_xml(date_filter)     
      # CHARTS TAB
      when "device_quantities"
        device_quantities_xml(date_filter)
      when "device_de_histogram"
        device_de_histogram_xml(date_filter)
      when "patch_de"
        patch_de_xml(date_filter)
      when "device_de"
        device_de_xml(date_filter)
      when "profile_de"
        profile_de_xml(date_filter)
      when "location_de"
        location_de_xml(date_filter)
      when "operator_de"
        operator_de_xml(date_filter)                        
      # charts detail
      when "proof_details"
        proof_details_xml(@proof, date_filter)
      when "proof_email"
        proof_details_xml(@proof, date_filter)  
      # ANALYSIS TAB
      when "location_pass_fail"
        location_pass_fail_xml(date_filter)
      when "device_pass_fail"
        device_pass_fail_xml(date_filter)
      when "profile_pass_fail"
        profile_pass_fail_xml(date_filter)
      when "operator_pass_fail"
        operator_pass_fail_xml(date_filter)      
      else
        false
      end
  
  end
  

  
end