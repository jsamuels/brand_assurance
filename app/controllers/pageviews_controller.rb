class PageviewsController < ApplicationController
  before_filter 	:authorize
  skip_before_filter :record_pageview
  
  def index
    @users = @member.users
  end

  def user_pageviews
    if params[:show_user]
      @show_user = User.find(params[:show_user])
      @user_pageviews = Pageview.get_users_last_50_views(params[:show_user])
    else
      redirect_to(:action => "index")
    end  
  end

  def pageview_date_filter
    if params[:pageview ]
      @pageview = Pageview.find(params[:pageview])
      @filter_values = {}
      @pageview.session.split("\n").each do |entry|
        @filter_values[entry.split(":")[0]] = entry.split(":")[1] if entry.split(":")[1]
      end  
    else
      redirect_to(:action => "index")
    end  
  end
  
  def pageview_user_agent
    if params[:pageview ]
      @pageview = Pageview.find(params[:pageview])
    else
      redirect_to(:action => "index")
    end  
  end
  

end
