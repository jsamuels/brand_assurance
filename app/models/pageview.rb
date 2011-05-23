class Pageview < ActiveRecord::Base
  belongs_to :user
#  write pageview analytics
#  Pageview.write( session, request )

  class << self
    def write( session, request )
      my_pageview = Pageview.new
      my_pageview.user_id = session[:user_id] || 0
      my_pageview.member_id = session[:member_id] || 0 # I changed DIST_NUM to member_id
      my_pageview.request_url = request.request_uri
      my_pageview.session = session[:date_filter].to_hash  if session[:date_filter]
      my_pageview.ip_address = request.remote_ip
      my_pageview.referer = request.env['HTTP_REFERER'] || 'none'
      my_pageview.user_agent = request.user_agent
      my_pageview.browser = Browser.name(request)
      my_pageview.os = Browser.os(request)
      my_pageview.save
                                   
    # Write to the rails log file - logger was added in rails 2.?
    # logger.info(my_pageview.attributes.inspect)
    # logger.info("= USER_ID: #{my_pageview.user_id}, MEMBER_ID: #{my_pageview.member_id}, REQ: #{my_pageview.request_url}, IP: #{my_pageview.ip_address}, REF: #{my_pageview.referer}, UA: #{my_pageview.user_agent}, DTS: #{DateTime.now}")
  
    end
  
    def get_users_last_50_views(user_id)
      my_query = "SELECT * 
                  FROM pageviews
                  WHERE user_id = #{user_id}        
                  ORDER BY created_at DESC LIMIT 50 "            
      find_by_sql [my_query]
    end
  
  end
end
