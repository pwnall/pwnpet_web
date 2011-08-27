class MachineActivationsController < ApplicationController
  # GET /machine_activations
  # GET /machine_activations.json
  def index
    @machine_activations = MachineActivation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @machine_activations }
    end
  end

  # GET /machine_activations/1
  # GET /machine_activations/1.json
  def show
    @machine_activation = MachineActivation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @machine_activation }
    end
  end

  # GET /machine_activations/new
  # GET /machine_activations/new.json
  def new
    @machine_activation = MachineActivation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @machine_activation }
    end
  end

  # GET /machine_activations/1/edit
  def edit
    @machine_activation = MachineActivation.find(params[:id])
  end

  # POST /machine_activations
  # POST /machine_activations.json
  def create
    @machine_activation = MachineActivation.new(params[:machine_activation])

    respond_to do |format|
      if @machine_activation.save
        format.html { redirect_to @machine_activation, :notice => 'Machine activation was successfully created.' }
        format.json { render :json => @machine_activation, :status => :created, :location => @machine_activation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @machine_activation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /machine_activations/1
  # PUT /machine_activations/1.json
  def update
    @machine_activation = MachineActivation.find(params[:id])

    respond_to do |format|
      if @machine_activation.update_attributes(params[:machine_activation])
        format.html { redirect_to @machine_activation, :notice => 'Machine activation was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @machine_activation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_activations/1
  # DELETE /machine_activations/1.json
  def destroy
    @machine_activation = MachineActivation.find(params[:id])
    @machine_activation.destroy

    respond_to do |format|
      format.html { redirect_to machine_activations_url }
      format.json { head :ok }
    end
  end
end
