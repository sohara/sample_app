class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :already_signed_in, :only => [:new, :create]
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
    
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      logger.info flash.inspect
      redirect_to @user
    else
      @user.password = ""
      @user.password_confirmation = ""
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to(users_path,:notice => "You cannot delete your own account.")
    else 
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end
  
  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end  
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
  
  def already_signed_in
    redirect_to(root_path, :notice => "You are already signed in.") if current_user
  end
       
end
