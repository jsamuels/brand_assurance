class BrandColorsController < ApplicationController
  before_filter 	:authorize

  # GET /brand_colors
  # GET /brand_colors.xml
  def index
   # @brand_colors = BrandColor.all
	if params[:brand_color] && !params[:brand_color].empty?
		@brand_colors = BrandColor.find(:all, :conditions => params_to_conditions(params), :order => "id")
	else
		@brand_colors = BrandColor.all

	end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brand_colors }
    end
  end

  # GET /brand_colors/1
  # GET /brand_colors/1.xml
  def show
    @brand_color = BrandColor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand_color }
    end
  end

  # GET /brand_colors/new
  # GET /brand_colors/new.xml
  def new
    @brand_color = BrandColor.new
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand_color }
   
    end
  end

  # GET /brand_colors/1/edit
  def edit
    @brand_color = BrandColor.find(params[:id])
  end

  # POST /brand_colors
  # POST /brand_colors.xml
  def create
    @brand_color = BrandColor.new(params[:brand_color])

    respond_to do |format|
      if @brand_color.save
        flash[:notice] = 'BrandColor was successfully created.'
        format.html { redirect_to(@brand_color) }
        format.xml  { render :xml => @brand_color, :status => :created, :location => @brand_color }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brand_color.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /brand_colors/1
  # PUT /brand_colors/1.xml
  def update
    @brand_color = BrandColor.find(params[:id])

    respond_to do |format|
      if @brand_color.update_attributes(params[:brand_color])
        flash[:notice] = 'BrandColor was successfully updated.'
        format.html { redirect_to(@brand_color) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand_color.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /brand_colors/1
  # DELETE /brand_colors/1.xml
  def destroy
    @brand_color = BrandColor.find(params[:id])
    @brand_color.destroy

    respond_to do |format|
      format.html { redirect_to(brand_colors_url) }
      format.xml  { head :ok }
    end
  end
end
