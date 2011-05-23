# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  KEYS = ['iAn7lkKN83hJf483L5Pd6']
  before_filter :authorize
  before_filter :set_init
  before_filter :record_pageview, :except => [:get_member_pref, :find_date_filter , :update_filter, :set_init, :activate? ]
  helper :all # include all helpers, all the time
  helper_method :get_member_pref
  
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # HELPER METHODS
  def get_member_pref(pref_name)
    if session[:member_id] != nil
      member = Member.find(session[:member_id])
      rs = MemberPreference.find_by_member_id(session[:member_id], :conditions => "pref = '#{pref_name}' ")
      if rs != nil
        rs.value
      end 
    end  
  end
  
  # DATE FILTER
  def find_date_filter
    session[:date_filter] ||= DateFilter.new
  end
  
  def update_filter
	date_filter = find_date_filter
	date_filter.member_id = session[:member_id]
    unless params[:dates][:location].blank?
      new_location = params[:dates][:location]
    else
      new_location = ''
    end
    # changing location re-sets the date filter
    if date_filter.location == new_location
      # same location
      date_filter.series = params[:dates][:series] || 'All'
      date_filter.start_date = params[:dates][:start_date]
      date_filter.end_date = params[:dates][:end_date]
      date_filter.press = params[:dates][:press] || 'All'
      date_filter.device = Device.get_device_or_nil(params[:dates][:device])
      date_filter.pass = params[:dates][:pass] || 'All'
      date_filter.profile = params[:dates][:profile] || 'All'
      date_filter.customer = params[:dates][:customer] || 'All'
      date_filter.operator = params[:dates][:operator] || 'All'
      date_filter.patch = params[:dates][:patch] || 'All'
      date_filter.limit = params[:dates][:limit] || '25' 
      # fail date_filter.inspect
    else
      # new location
      date_filter.location = new_location
      #  make sure so set location before .clear! to ensure .clear! gets the correct defaults for this location
      date_filter.clear!
    end
    
    redirect_to(:controller => date_filter.cur_controller, :action => date_filter.cur_action)
  end
  
  def set_init
    if User.find_by_id(session[:user_id]) && Member.find_by_id(session[:member_id])
      @accordian_active = 0
      @user ||= User.find_by_id(session[:user_id])
      @member ||= Member.find_by_id(session[:member_id])
      @devices ||= Device.find(:all, :conditions => { :member_id => session[:member_id], :active => 1 }, :order => "name")
      @locations ||= Device.find(:all, :conditions => { :member_id => session[:member_id], :active => 1 }, :group => "location")
      @divisions ||= Division.find(:all, :conditions => { :member_id => session[:member_id] } ) 
      @members ||= Member.all
      @date_filter ||= find_date_filter
      @date_filter.member_id = @member.id
    end
  end

  # AUTHENTICATE / LOGIN
  def activate?
  # if called from /login warn that account is about to expire, then ok
     if get_member_pref('exp_date').blank?
       fail_activate
     else
       my_exp = decrypt(get_member_pref('exp_date')).to_date
       days_til_expire = my_exp - Time.now().to_date     
       if days_til_expire <= 30
          if days_til_expire <= 0
            fail_activate
          else
            flash[:notice] = "This account will expire in #{days_til_expire} days" 
          end
        else
          # more than 30 days 'til expire 
          return true
        end
     end
  end

private

    def record_pageview
    	unless params[:key] &&  KEYS.include?(params[:key])
           		Pageview.write( session, request )
    	end  
    end

    def	authorize
    	if User.find_by_id(session[:user_id])
    		user = User.find_by_id(session[:user_id])
    		session[:user_level] = user.level
    		session[:user_name] = user.name
    		session[:member_id] = user.member_id
    	elsif params[:key] &&  KEYS.include?(params[:key]) && User.find_by_id(1)
    		#authorize if key exists
		    user = User.find_by_id(1)
		    session[:user_id] = 1
    		session[:user_level] = user.level
    		session[:user_name] = user.name
    		session[:member_id] = user.member_id
		
    	else
    		flash[:notice] = "Please log in"
    		redirect_to(:controller => "login", :action => "login")
    	end
    /
    	unless User.find_by_id(session[:user_id])
    		flash[:notice] = "Please log in"
    		redirect_to(:controller => "login", :action => "login")
    	else
    		user = User.find_by_id(session[:user_id])
    		session[:user_level] = user.level
    		session[:user_name] = user.name
    		session[:member_id] = user.member_id
    	end
    /
    end	

    def	authorize_level(access_level)
    	unless session[:user_level] > access_level
    		flash[:notice] = "You must be an administrator to acces this page."
    		#redirect to login index
    		redirect_to(:controller => "login", :action => "index" )
    	end
    end

    def fail_activate
    return true
     # my_exp = decrypt(get_member_pref('exp_date')).to_date.to_s(:long) unless #get_member_pref('exp_date').nil?
    #  flash[:notice] = "This subscription expired on,<br/> #{my_exp}.<br/>
  #    Contact Vertis Communications<br/>to update your subscription."
   #   session[:user_id] = nil
   # 	session[:user_level] = nil
  	#	session[:user_name] = nil
  	#	session[:member_id] = nil
  	#	false
    end

    def decrypt(encrypted_string)
#this has to be flush left to work!
key_value = %Q{-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,D5812EA77267A29A

gMdM6MRnUxeBbe/Jn0CHwFj6c2SfSgTwuU6lFcFL+9sj2PLsM44j2K1mxpc8Ks4g
3gzOKH+rcwX3U665B1IJY0xk/F5No4iFwH0TABozibd6xZlhUmbW/6O3DIjI/Qqo
+ZbEGJ0ULoI7DCGByis5twuOIXmz2ChumTt6a1GvbByS/SYgFKCm2t4AKtYItfyJ
6xLpYT0hzGQ+1rTJdW+DX8paujDM38DqUfqcdsS75K8Uch59dy2uNmGe/6tWX/5Z
6KVV8hnxLmsirpYQp6rNmYFq6ezQAdqk4ubVFVF2YezcD926xiN5VRiAe9cYM5Xm
ubYvWv3x8U9a+htc5/jBxMAD66wBibggOxvyveywYVa+oq3Zea8K0ZPHnI7iUT4T
BB/pAQuzaqqCRAWA520zrcvjDFRRob2WBsPw57UAC7OuSBrY3oUlN1EICdmcW7B3
Wbl3kYHB+rf+tjDVJEw32Vnvaegs/NTNJ9dg/88VYncMyco/ztUNbLEEDsIhZEv3
KN4lcgTaWeJ+Q2JnhNFIiSWEA6hUhPZjYprr/L1s7nVkeqbHAzR6E1e4mAfhSfVU
tnLOu01gCCmlBOOaFArr+k/EHQO5e9cAjQup++FE9hdHitU6A9EX9ZJzKjd2ceaH
XWuShrLvTWZT0ReZVNXrJVXUpk9GYmyA6ZEhR3Z01/lZg00dMKERYB3rwt2fXNlk
45vTfqFsVLVw/lJz4ReotbtivukTwhGTGRml3vnftjZyvBeURPtRCe2Gm7DxvLvu
KOT+5OCQcYE3+IKDpVFOdrVj8pjzQbkLL478u7fzl7+i3CG7qqopPsaVDmr5oUG/
FwcZKcs19o9RFeM4rJf9g28tPSva0v4w/ji0vEaU+Q6bnc8bgykSzHb9jnSWOHms
xAcBCIKx410kCaRdLLVCcjB2yrMaki3t+d1NEGhO9Hcx6e1Ze3WmSx3vWPq9tfJO
sWNrtl7+dt5oMgn2+E/mdVATpHl93jMxkqwpDBahGs3Nut1+08XzR7nzB7mC0Lp2
DCOcOEM92Y+u1K5jm9T1u16QP+6nREJPTuCp9giS4d+POTJjMqdUOkW0rjqs9dE9
dp2CIZR1ECZXLcZ/tle4Cu7DRGQWu7HS9tjkr4ygr6iUKPxzO5LF+f6ZNpYST4fS
unfhB0T5dGSYLrQGbLvLrab+YJbAt2cFBEOAVsd16PROw7/UYn6Ow1BXU8mCu805
o7KPBXxdJ2oDR+0BN5n3gCqYmPVmSyo2yIAZop1pNR7brVNcQEeaYnRSkXCAMG50
366J/8tlKe7XXCMsuAP0NQBB3xFkdfXiO+Ex1s8i2QZRJEBE6YXifOrAAc2FgPtm
bRH+c9/YIo7D+RSDvo1X9y9oTRWf2X/R97k+E1xYJ1Plxnuv3aEmZ6lARp9ewchN
og09xZZVM+itrLpv0OFCtw5kSKDzknbXw4yV6Zr4vYrMO5GTuJXuRfrnnLGdIIAf
FcGb3OP/2B1BWQQb8+GD+0wF9f/ahoh4dk+evEPkGvXqkNsnwLvvVnO0IYOMFJzT
SESfxyN9flO4YKyiNDACUKjnL2tUu70mWP6IxqeBJ+WK2ic9wBcaPjixVWo/K+lu
-----END RSA PRIVATE KEY-----}
    private_key = OpenSSL::PKey::RSA.new(key_value,'vat2001')
    string = private_key.private_decrypt(Base64.decode64(encrypted_string))
    end
    
  def params_to_conditions(params)
    # control_bars?control_bar[name]=vinod,bob,canada,ANOTHER&member_id=1
    condition_hash = {}
    condition_hash.merge!(params[self.controller_name.singularize]) if params[self.controller_name.singularize]    
    keys = []
    values = []
    condition_hash.each do |key, value|
      keys << key.to_s + ' IN (?) '
      values.push(value.to_s.split(/,/))
    end
    conditions = values.unshift(keys.join(' AND ')) 
  end
end
