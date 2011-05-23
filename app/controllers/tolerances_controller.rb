class TolerancesController < ApplicationController
  before_filter 	:authorize
  # GET /tolerances
  # GET /tolerances.xml
  def index
   # @tolerances = Tolerance.all
	if params[:tolerance] && !params[:tolerance].empty?
		@tolerances = Tolerance.find(:all, :conditions => params_to_conditions(params), :order => "id")
	else
		@tolerances = Tolerance.all

	end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tolerances }
    end
  end

  # GET /tolerances/1
  # GET /tolerances/1.xml
  def show
    @tolerance = Tolerance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tolerance }
    end
  end

  # GET /tolerances/new
  # GET /tolerances/new.xml
  def new
    @tolerance = Tolerance.new(params[:tolerance])
	
    respond_to do |format|
    if @tolerance.save
      format.html # new.html.erb
      format.xml  { render :xml => @tolerance }
     else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tolerance.errors, :status => :unprocessable_entity }
      end
  	  end
  end

  # GET /tolerances/1/edit
  def edit
    @tolerance = Tolerance.find(params[:id])
  end

  # POST /tolerances
  # POST /tolerances.xml
  def create
    @tolerance = Tolerance.new(params[:tolerance])

    respond_to do |format|
      if @tolerance.save
        flash[:notice] = 'Tolerance was successfully created.'
        format.html { redirect_to(@tolerance) }
        format.xml  { render :xml => @tolerance, :status => :created, :location => @tolerance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tolerance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tolerances/1
  # PUT /tolerances/1.xml
  def update
    @tolerance = Tolerance.find(params[:id])

    respond_to do |format|
      if @tolerance.update_attributes(params[:tolerance])
        flash[:notice] = 'Tolerance was successfully updated.'
        format.html { redirect_to(@tolerance) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tolerance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tolerances/1
  # DELETE /tolerances/1.xml
  def destroy
    @tolerance = Tolerance.find(params[:id])
    @tolerance.destroy

    respond_to do |format|
      format.html { redirect_to(tolerances_url) }
      format.xml  { head :ok }
    end
  end
end
