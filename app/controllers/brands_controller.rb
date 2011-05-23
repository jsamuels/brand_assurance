class BrandsController < ApplicationController
   before_filter 	:authorize
   
  # GET /brands
  # GET /brands.xml
  def index
  #fail params.inspect
   #@brands = Brand.all
   #sample code
   #params[:object] && !params[:object].empty
	#if params[:brand] && params[:brand][:name]
	if params[:brand] && !params[:brand].empty?
		@brands = Brand.find(:all, :conditions => params_to_conditions(params), :order => "id")
	else
		@brands = Brand.all

	end 
    respond_to do |format|
      format.html # index.html.erb
      #format.html redirect_to(:controller => "login", :action => "login") 
      format.xml  { render :xml => @brands }
    end
  end


  # GET /brands/1
  # GET /brands/1.xml
  def show
    @brands = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brands }
    end
  end

  # GET /brands/new
  # GET /brands/new.xml
  def new
    @brands = Brand.new

    respond_to do |format|
      
        format.html # new.html.erb
        format.xml  { render :xml => @brands }
      
    end
  end

  # GET /brands/1/edit
  def edit
    @brands = Brand.find(params[:id])
  end

  # POST /brands
  # POST /brands.xml
  def create
    @brands = Brand.new(params[:brands])

    respond_to do |format|
      if @brands.save
        flash[:notice] = 'Brands was successfully created.'
        format.html { redirect_to(@brands) }
        format.xml  { render :xml => @brands, :status => :created, :location => @brands }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brands.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @brands = Brand.find(params[:id])

    respond_to do |format|
      if @brands.update_attributes(params[:brands])
        flash[:notice] = 'Brands was successfully updated.'
        format.html { redirect_to(@brands) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brands.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brands = Brand.find(params[:id])
    @brands.destroy

    respond_to do |format|
      format.html { redirect_to(brands_url) }
      format.xml  { head :ok }
    end
  end
end
