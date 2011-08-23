class ShellSessionsController < ApplicationController
  # GET /shell_sessions
  # GET /shell_sessions.json
  def index
    @shell_sessions = ShellSession.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shell_sessions }
    end
  end

  # GET /shell_sessions/1
  # GET /shell_sessions/1.json
  def show
    @shell_session = ShellSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shell_session }
    end
  end

  # GET /shell_sessions/new
  # GET /shell_sessions/new.json
  def new
    @shell_session = ShellSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @shell_session }
    end
  end

  # GET /shell_sessions/1/edit
  def edit
    @shell_session = ShellSession.find(params[:id])
  end

  # POST /shell_sessions
  # POST /shell_sessions.json
  def create
    @shell_session = ShellSession.new(params[:shell_session])

    respond_to do |format|
      if @shell_session.save
        format.html { redirect_to @shell_session, :notice => 'Shell session was successfully created.' }
        format.json { render :json => @shell_session, :status => :created, :location => @shell_session }
      else
        format.html { render :action => "new" }
        format.json { render :json => @shell_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shell_sessions/1
  # PUT /shell_sessions/1.json
  def update
    @shell_session = ShellSession.find(params[:id])

    respond_to do |format|
      if @shell_session.update_attributes(params[:shell_session])
        format.html { redirect_to @shell_session, :notice => 'Shell session was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @shell_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shell_sessions/1
  # DELETE /shell_sessions/1.json
  def destroy
    @shell_session = ShellSession.find(params[:id])
    @shell_session.destroy

    respond_to do |format|
      format.html { redirect_to shell_sessions_url }
      format.json { head :ok }
    end
  end
end
