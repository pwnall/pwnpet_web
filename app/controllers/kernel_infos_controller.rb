class KernelInfosController < ApplicationController
  # GET /kernel_infos
  # GET /kernel_infos.xml
  def index
    @kernel_infos = KernelInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @kernel_infos }
    end
  end

  # GET /kernel_infos/1
  # GET /kernel_infos/1.xml
  def show
    @kernel_info = KernelInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @kernel_info }
    end
  end

  # GET /kernel_infos/new
  # GET /kernel_infos/new.xml
  def new
    @kernel_info = KernelInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @kernel_info }
    end
  end

  # GET /kernel_infos/1/edit
  def edit
    @kernel_info = KernelInfo.find(params[:id])
  end

  # POST /kernel_infos
  # POST /kernel_infos.xml
  def create
    @kernel_info = KernelInfo.new(params[:kernel_info])

    respond_to do |format|
      if @kernel_info.save
        format.html { redirect_to(@kernel_info, :notice => 'Kernel info was successfully created.') }
        format.xml  { render :xml => @kernel_info, :status => :created, :location => @kernel_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @kernel_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /kernel_infos/1
  # PUT /kernel_infos/1.xml
  def update
    @kernel_info = KernelInfo.find(params[:id])

    respond_to do |format|
      if @kernel_info.update_attributes(params[:kernel_info])
        format.html { redirect_to(@kernel_info, :notice => 'Kernel info was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @kernel_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /kernel_infos/1
  # DELETE /kernel_infos/1.xml
  def destroy
    @kernel_info = KernelInfo.find(params[:id])
    @kernel_info.destroy

    respond_to do |format|
      format.html { redirect_to(kernel_infos_url) }
      format.xml  { head :ok }
    end
  end
end
