class CommandResultsController < ApplicationController
  # GET /command_results
  # GET /command_results.json
  def index
    @command_results = CommandResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @command_results }
    end
  end

  # GET /command_results/1
  # GET /command_results/1.json
  def show
    @command_result = CommandResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @command_result }
    end
  end

  # GET /command_results/new
  # GET /command_results/new.json
  def new
    @command_result = CommandResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @command_result }
    end
  end

  # GET /command_results/1/edit
  def edit
    @command_result = CommandResult.find(params[:id])
  end

  # POST /command_results
  # POST /command_results.json
  def create
    @command_result = CommandResult.new(params[:command_result])

    respond_to do |format|
      if @command_result.save
        format.html { redirect_to @command_result, :notice => 'Command result was successfully created.' }
        format.json { render :json => @command_result, :status => :created, :location => @command_result }
      else
        format.html { render :action => "new" }
        format.json { render :json => @command_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /command_results/1
  # PUT /command_results/1.json
  def update
    @command_result = CommandResult.find(params[:id])

    respond_to do |format|
      if @command_result.update_attributes(params[:command_result])
        format.html { redirect_to @command_result, :notice => 'Command result was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @command_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /command_results/1
  # DELETE /command_results/1.json
  def destroy
    @command_result = CommandResult.find(params[:id])
    @command_result.destroy

    respond_to do |format|
      format.html { redirect_to command_results_url }
      format.json { head :ok }
    end
  end
end
