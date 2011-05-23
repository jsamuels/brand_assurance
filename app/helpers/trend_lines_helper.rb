module TrendLinesHelper
  def get_trend_zones(date_filter)
    #this sets the background of the chart green to yellow to red
    my_return = "<trendLines>"
    my_return += "<line startValue='#{get_member_pref('usl')}' displayValue='USL' lineThickness='2' color='FF0000' showOnTop='1' dashed='1' dashGap='5' isTrendZone='0' />"
    my_return += "#{trend_zones_green}
                  #{trend_zones_yellow}
                  #{trend_zones_red}"             
   my_return += "</trendLines>"   
  end

  def get_labch_trend_zones(date_filter)
    my_return = "<trendLines>"
    my_return += "<line startValue='0' displayValue='Target' lineThickness='2' color='FF0000' showOnTop='1' dashed='1' dashGap='5' isTrendZone='0' />"
    my_return += "#{labch_trend_zones_green}
                  #{labch_trend_zones_yellow}
                  #{labch_trend_zones_red}"
    my_return += "</trendLines>" 
  end

private  
  def trend_zones_green
    pass = get_member_pref("pass").to_i || 2
    pass -= 1
    my_zones = ""
    (0..pass).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{40}' color='008000' showOnTop='0' isTrendZone='1' />"
    end 
    return my_zones
  end
  def labch_trend_zones_green
    pass = get_member_pref("pass").to_i || 2
    start = pass * -1
    pass -= 1
    
    my_zones = ""
    (start..pass).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{40}' color='008000' showOnTop='0' isTrendZone='1' />"
    end 
    return my_zones
  end
  def trend_zones_yellow
    pass = get_member_pref("pass").to_i || 2
    warn = get_member_pref("warn").to_i || 3
    warn -= 1
    my_zones = ""
    (pass..warn).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{40}' color='FFFF00' showOnTop='0' isTrendZone='1' />"
    end
    return my_zones
  end
  def labch_trend_zones_yellow
    pass = get_member_pref("pass").to_i || 2
    warn = get_member_pref("warn").to_i || 3
    warn -= 1
    my_zones = ""
    (pass..warn).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{40}' color='FFFF00' showOnTop='0' isTrendZone='1' />"
    end
    (-(warn+1)...-pass).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{40}' color='FFFF00' showOnTop='0' isTrendZone='1' />"
    end
    return my_zones
  end
  def trend_zones_red
    warn = get_member_pref("warn").to_i || 3
    my_zones = ""
    (warn..100).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{(x+10)*2}' color='FF0000' showOnTop='0' isTrendZone='1' />"
    end  
    return my_zones
  end
  def labch_trend_zones_red
    warn = get_member_pref("warn").to_i || 3
    my_zones = ""
    (warn..100).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{(x+10)*2}' color='FF0000' showOnTop='0' isTrendZone='1' />"
    end 
    (-100...-warn).each do |x|
      my_zones += "<line startValue='#{x}' displayValue=' ' endValue='#{x+1}' alpha='#{(x+10)*2}' color='FF0000' showOnTop='0' isTrendZone='1' />"
    end 
    return my_zones
  end
end