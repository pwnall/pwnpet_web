class NetAddressesController < ApplicationController
  # GET /net_addresses
  # GET /net_addresses.xml
  def index
    @net_addresses = NetAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @net_addresses }
    end
  end

  # GET /net_addresses/1
  # GET /net_addresses/1.xml
  def show
    @net_address = NetAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @net_address }
    end
  end

  # GET /net_addresses/new
  # GET /net_addresses/new.xml
  def new
    @net_address = NetAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @net_address }
    end
  end

  # GET /net_addresses/1/edit
  def edit
    @net_address = NetAddress.find(params[:id])
  end

  # POST /net_addresses
  # POST /net_addresses.xml
  def create
    @net_address = NetAddress.new(params[:net_address])

    respond_to do |format|
      if @net_address.save
        format.html { redirect_to(@net_address, :notice => 'Net address was successfully created.') }
        format.xml  { render :xml => @net_address, :status => :created, :location => @net_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @net_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /net_addresses/1
  # PUT /net_addresses/1.xml
  def update
    @net_address = NetAddress.find(params[:id])

    respond_to do |format|
      if @net_address.update_attributes(params[:net_address])
        format.html { redirect_to(@net_address, :notice => 'Net address was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @net_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /net_addresses/1
  # DELETE /net_addresses/1.xml
  def destroy
    @net_address = NetAddress.find(params[:id])
    @net_address.destroy

    respond_to do |format|
      format.html { redirect_to(net_addresses_url) }
      format.xml  { head :ok }
    end
  end
end
