class ProofsController < ApplicationController
  include NumberFormulas  # mix-in from /lib
  before_filter 	:authorize
  
  def index
  end
  
  def device_quantities
    @date_filter.chart_type = 'Column3D.swf'
    @sticker_count = Device.device_sticker_quantities(@date_filter)
    @measurement_count = Device.device_measurements(@date_filter )
    @measurement_pass_count = Device.device_measurements(@date_filter, {:pass => 'Pass'} )
    @measurement_pass_percent = (format_num((@measurement_pass_count.to_f / @measurement_count.to_f),2) * 100).to_i
    @sq_inches_of_paper = Device.device_proofs_size(@date_filter)
  	render(:action => "index")
  end
  
  def device_de_histogram
    @date_filter.chart_type = 'Bar2D.swf'
  	render(:action => "index")    
  end
  
  def patch_de
    @date_filter.chart_type = 'Bar2D.swf'
  	render(:action => "index")    
  end
   
  def patch_lab 
    @date_filter.chart_type = '' 
    if @date_filter.profile
  	  @patches = Patch.lab_proof_avg(@date_filter)
  	end    
  end     
    
  def device_de
    @date_filter.chart_type = 'Column3D.swf'
  	render(:action => "index")
  end
  
  def profile_de
    @date_filter.chart_type = 'Column3D.swf'
  	render(:action => "index")
  end
  
  def location_de
    @date_filter.chart_type = 'Column3D.swf'
  	render(:action => "index")
  end
  
  def operator_de
    @date_filter.chart_type = 'Column3D.swf'
  	render(:action => "index")
  end

  def set_t_rgb
    limit = 1000
    limit = params[:limit] if params[:limit]
    @patches = Patch.find_t_rgb_is_null(limit)
    @patches.each do |patch|
      patch.update_rgb
    end
    
    render(:text => Patch.find_t_rgb_remaining_to_convert )
  end

# Analysis
  def location_pass_fail
    @date_filter.chart_type = 'Column3D.swf'
    render(:action => "index")
  end
  
  def device_pass_fail
    @date_filter.chart_type = 'Column3D.swf'
    render(:action => "index")
  end
  
  def profile_pass_fail
    @date_filter.chart_type = 'Column3D.swf'
    render(:action => "index")
  end

  def operator_pass_fail
    @date_filter.chart_type = 'Column3D.swf'
    render(:action => "index")
  end

  # GET /proofs
  # GET /proofs.xml
  def index
	if params[:proof] && params[:proof][:job_id]
	if params[:proof][:job_id] == ""
		@proofs = Proof.all
	else
		@proofs = Proof.find(:all, :conditions => params_to_conditions(params), :order => "id")
	end
	else
	@proofs = Proof.all
	end 
#    @proofs = Proof.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proofs }	         
    end

  end

  # GET /proofs/1
  # GET /proofs/1.xml
  def show
    @proof = Proof.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proof }
    end
  end



  # POST /proofs
  # POST /proofs.xml
  def create
    @proof = Proof.new(params[:proof])

    respond_to do |format|
      if @proof.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to(@proof) }
        format.xml  { render :xml => @proof, :status => :created, :location => @proof }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proof.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /proofs/1
  # PUT /proofs/1.xml
  def update
  
    @proofs = Proof.find(params[:id])

    respond_to do |format|
      if @proofs.update_attributes(params[:proof])
        flash[:notice] = 'Proofs was successfully updated.'
        format.html { redirect_to(@proofs) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proofs.errors, :status => :unprocessable_entity }
      end
    end
  end
  # GET /proofs/new
  # GET /proofs/new.xml
  def new
    @proof = Proof.new(params[:proof])
	if @proof.save
    	respond_to do |format|
      	 format.html # new.html.erb
      	 #format.html { render :text => %Q{Hello World!} }
      	 format.xml  { render :xml => @proof, :status => :created, :location => @proof }
    	end
    end
  end
private

end
