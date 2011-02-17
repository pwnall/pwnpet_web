class SshCredentialsController < ApplicationController
  # GET /ssh_credentials
  # GET /ssh_credentials.xml
  def index
    @ssh_credentials = SshCredential.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ssh_credentials }
    end
  end

  # GET /ssh_credentials/1
  # GET /ssh_credentials/1.xml
  def show
    @ssh_credential = SshCredential.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ssh_credential }
    end
  end

  # GET /ssh_credentials/new
  # GET /ssh_credentials/new.xml
  def new
    @ssh_credential = SshCredential.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ssh_credential }
    end
  end

  # GET /ssh_credentials/1/edit
  def edit
    @ssh_credential = SshCredential.find(params[:id])
  end

  # POST /ssh_credentials
  # POST /ssh_credentials.xml
  def create
    @ssh_credential = SshCredential.new(params[:ssh_credential])

    respond_to do |format|
      if @ssh_credential.save
        format.html { redirect_to(@ssh_credential, :notice => 'Ssh credential was successfully created.') }
        format.xml  { render :xml => @ssh_credential, :status => :created, :location => @ssh_credential }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ssh_credential.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ssh_credentials/1
  # PUT /ssh_credentials/1.xml
  def update
    @ssh_credential = SshCredential.find(params[:id])

    respond_to do |format|
      if @ssh_credential.update_attributes(params[:ssh_credential])
        format.html { redirect_to(@ssh_credential, :notice => 'Ssh credential was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ssh_credential.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ssh_credentials/1
  # DELETE /ssh_credentials/1.xml
  def destroy
    @ssh_credential = SshCredential.find(params[:id])
    @ssh_credential.destroy

    respond_to do |format|
      format.html { redirect_to(ssh_credentials_url) }
      format.xml  { head :ok }
    end
  end
end
