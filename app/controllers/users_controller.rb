class UsersController < ApplicationController
  # before_filter that validates the current user's ability to make changes
  def current_user_can_edit_user
    @user = User.find_by_param(params[:id])
    bounce_user unless @user && @user.can_edit?(current_user)
  end
  private :current_user_can_edit_user
  before_filter :current_user_can_edit_user, :only => [:edit, :update, :destroy]
  
  # before_filter that validates the current user's ability to see an account
  def current_user_can_read_user
    @user = User.find_by_param(params[:id])
    bounce_user unless @user && @user.can_read?(current_user)
  end
  private :current_user_can_read_user
  before_filter :current_user_can_read_user, :only => [:show]
  
  # before_filter that validates the current user's ability to list accounts  
  def current_user_can_list_users
    bounce_user unless User.can_list_users? current_user
  end
  private :current_user_can_list_users
  before_filter :current_user_can_list_users, :only => [:index]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.json  { render :json => @user }
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        self.current_user = @user
        format.json  { render :json => @user, :status => :created, :location => @user }
        format.html { redirect_to session_path }
      else
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
        format.html { render :action => :new }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
