# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def set_date_filter_controller_action
    #  this is called in the header of application.html 
    #  keeps user on same screen when updating filter
    if session[:date_filter]
      session[:date_filter].cur_controller = controller.controller_name
      session[:date_filter].cur_action = controller.action_name
    end
  end
  
  def member
    @member
  end
  
  def accordian_selected
    case controller.controller_name
    when  "login"
      # need to determine users
      case controller.action_name
      when /user/
        6
      when "index"
        true if @user  
      else
        false
      end      
    when  "members"
      5
    when "devices"
      #  need to detrmine queue vs entry
      case controller.action_name
      when /proof_email/
        false  
      when /location|division/
        0 
      else
        1 # or 1
      end
    when "proofs"
      case controller.action_name
      when /_pass_fail/
        3
      else
        2
      end    
    when "pageviews"
      4    
    else
      false
    end    
  end

  def accordian_access(user_level)
    if session[:user_id]
      user = User.find(session[:user_id])
      if user.level && user.level > user_level
        true
      else
        false
      end
    else
      false
    end    
  end
  
  def show_date_filter_patch_selector
    if controller.action_name =~ /trend_|device_de|location_de/i
      true
    else
      false
    end    
  end
  
  def show_date_filter_limit_selector
    if controller.action_name =~ /trend_/i
      true
    else
      false
    end
  end
  
  def tab_link(name, controller, action, param=nil, value=nil)
    #  look at Rails link_to method to see how to pass optional params ...  REFACTOR HERE
   if param.nil?
      link_to( name, {:controller => controller, :action => action}, :style => chart_selected_style(controller, action) ) + "<br/>"
    else
      # this was only for the status tab, but it selected every device because it only uses controller / action to determine what is selected - not params
      link_to( name, {:controller => controller, :action => action, param => value }, :style => chart_selected_style(controller, action, param, value) ) + "<br/>"
    end    
  end
  
  def chart_selected_style(controller, action, param=nil, value=nil)
    #  I could not get this to work for the jQuery elements in the CSS so ...
    if current_page?(:controller => controller, :action => action)
      if param.nil?
        "color: #000080; background: #CCCCCC"
      elsif value == params[:location] # WOW is this cuppled - REFACTOR HERE
        "color: #000080; background: #CCCCCC"  
      elsif value.to_s == params[:division].to_s # WOW is this cuppled - REFACTOR HERE
        "color: #000080; background: #CCCCCC"  
      else  
        ""
      end    
    else
      ""
    end    
  end
  
  def trend_chart_max(dE)
    max_val = get_member_pref("chart_max").to_f || 10.0
    if dE.to_f > max_val
      max_val.to_s
    else
      dE
    end  
  end      
      
  def lab_row(patch, row_class)   
    row_style = "background:  #{patch.hex_color};" 
    row_style << "color:    #CCCCCC;" if (patch.red + patch.blue + patch.green) < 200    
		lab_row = "<tr valign='top' class='#{row_class}' style='#{row_style}' >"
  end


end
