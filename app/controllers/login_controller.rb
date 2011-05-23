class LoginController < ApplicationController
	before_filter 	:authorize, :except => [:login, :index]
	# restrict admin access
	before_filter	  :except => [:login, :index, :logout] do  |c| c.send(:authorize_level, 5) end  
	
  def login
    # this gets called by a redirect from index
    # only if the user is not logged in correctly i.e. invalid user/password
		session[:user_id] = nil
		@accordian_active = false
		user = User.authenticate(params[:name], params[:password])
		if user
      session[:user_id] = user.id
      session[:member_id] = user.member.id
      if activate?
			  redirect_to(:controller => "login", :action => "index")
      else
        redirect_to(:controller => "login", :action => "login") 
      end
		elsif request.post?
			flash.now[:notice] = "Invalid user/password combination"
		end	
  end

  def logout
  	session[:user_id] = nil
  	flash[:notice] = "Logged out"
  	redirect_to(:action => "login")
  end

  def index
    unless User.find_by_id(session[:user_id]) # this is where you go if you are logged in
      #log in by URL, i.e. ColorStore
      if params[:login] != nil && params[:password] != nil then
  			@url_user = params[:login] 
  			@url_password = params[:password]
  			#find the user
  			@user = User.authenticate(params[:login], params[:password])
  			if @user
  				session[:user_id] = @user.id
  				session[:member_id] = @user.member.id
  			else
  				flash[:notice] = "Invalid user/password combination"
  				redirect_to(:action => "login")
  				return
  			end
  		else
  			flash[:notice] = "Please log in"
  			redirect_to(:action => "login")
  			return
  		end
  	end
  	
  	# if we get to here we are logged in
  	redirect_to(:controller => "devices", :action => "locations")
  end
  
  def add_user
  	@user=User.new(params[:user])
  	if request.post? and @user.save
  		flash.now[:notice] = "User #{@user.name} created"
  		@user = User.new
  	end	
  end

  def edit_user   
   @user=User.find(params[:id])
   flash.now[:notice] = "User #{@user.name}."
  end
  
  def update_user
  	 @user=User.find(params[:id])
  	 level = params[:user][:level]
  	 name = params[:user][:name]
  	 member_id =  params[:user][:member_id]
    if @user.update_attributes(:level => level , :name => name, :member_id => member_id )
  		flash.now[:notice] = "User #{name} updated."
  		redirect_to(:action => "list_users")
  	else
  		flash.now[:notice] = "Error updating user."
  		render( :action => "edit_user" )
  	end
  end

  def delete_user
  	if request.post?
  		user=User.find(params[:id])  		
  		begin
  			user.destroy
  			flash[:notice] = "User #{user.name} deleted"
  		rescue Exception => e
  			flash[:notice] = e.message
  		end	
  	end
  	redirect_to(:action => list_users)
  end

  def list_users
  	@all_users = User.find(:all)
  end
  
    
end
