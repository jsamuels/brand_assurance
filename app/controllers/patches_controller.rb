class PatchesController < ApplicationController
  # GET /patches
  # GET /patches.xml
  def index
    @patches = Patch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patches }
    end
  end

  # GET /patches/1
  # GET /patches/1.xml
  def show
    @patch = Patch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patch }
    end
  end

  # GET /patches/new
  # GET /patches/new.xml
  def new
    @patch = Patch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patch }
    end
  end

  # GET /patches/1/edit
  def edit
    @patch = Patch.find(params[:id])
  end

  # POST /patches
  # POST /patches.xml
  def create
    @patch = Patch.new(params[:patch])

    respond_to do |format|
      if @patch.save
        flash[:notice] = 'Patch was successfully created.'
        format.html { redirect_to(@patch) }
        format.xml  { render :xml => @patch, :status => :created, :location => @patch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @patch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /patches/1
  # PUT /patches/1.xml
  def update
    @patch = Patch.find(params[:id])

    respond_to do |format|
      if @patch.update_attributes(params[:patch])
        flash[:notice] = 'Patch was successfully updated.'
        format.html { redirect_to(@patch) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patches/1
  # DELETE /patches/1.xml
  def destroy
    @patch = Patch.find(params[:id])
    @patch.destroy

    respond_to do |format|
      format.html { redirect_to(patches_url) }
      format.xml  { head :ok }
    end
  end
end
