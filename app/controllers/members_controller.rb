class MembersController < ApplicationController
  before_filter 	:authorize
  
  def index
  end

  def set_member
    @user=User.find(params[:id])
    user_member_id = params[:user][:member_id]
    name = @user.name
    session[:member_id] = user_member_id
    
    if @user.update_attributes(:member_id => user_member_id , :name => name )
  		flash.now[:notice] = "User #{name} updated."
  		redirect_to (:action => "index")
  	else
  		flash.now[:notice] = "Error updating user."
  		render( :action => "index" )
  	end
  end  

  def show
  
  
      @members = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @members }
    end
   # redirect_to(:action => 'index')
  end


  def new
    @member = Member.new
  end

  def edit
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(params[:member])
    if @member.save
      flash[:notice] = 'Member was successfully created.'
      redirect_to(@member) 
    else
      render :action => "new" 
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update_attributes(params[:member])
      flash[:notice] = 'Member was successfully updated.'
      redirect_to(@member) 
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to(members_url)
  end
end
