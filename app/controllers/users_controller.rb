class UsersController < ApplicationController
  # regenerate this controller with
  # bin/rails generate hot_glue:scaffold User --gd --related-sets='roles' --include='name,roles' --smart-layout

  helper :hot_glue
  include HotGlue::ControllerHelper

  
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol == :turbo_stream }
  
  
  def load_user
    @user = User.find(params[:id])
  end
  
  def load_all_users 
    @users = User.page(params[:page])
    
  end

  def index
    load_all_users
  end

  def new
    @user = User.new()
    
  end

  def create
    modified_params = modify_date_inputs_on_params(user_params.dup, nil, []) 

      
    
    @user = User.new(modified_params)
    
    

    if @user.save
      flash[:notice] = "Successfully created #{@user.name}"
      
      load_all_users
      render :create
    else
      flash[:alert] = "Oops, your user could not be created. #{@hawk_alarm}"
      @action = "new"
      render :create, status: :unprocessable_entity
    end
  end



  def show
    redirect_to edit_user_path(@user)
  end

  def edit
    @action = "edit"
    render :edit
  end

  def update
    flash[:notice] = +''
    flash[:alert] = nil
    

    modified_params = modify_date_inputs_on_params(update_user_params.dup, nil, []) 
    

    
      
    
    if @user.update(modified_params)
    
      
      flash[:notice] << "Saved #{@user.name}"
      flash[:alert] = @hawk_alarm if @hawk_alarm
      render :update
    else
      flash[:alert] = "User could not be saved. #{@hawk_alarm}"
      @action = "edit"
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    
    begin
      @user.destroy
      flash[:notice] = 'User successfully deleted'
    rescue StandardError => e
      flash[:alert] = 'User could not be deleted'
    end 
    load_all_users
  end



  def user_params
    params.require(:user).permit(:name, role_ids: [])
  end

  def update_user_params
    params.require(:user).permit(:name, role_ids: [])
  end

  def namespace
    
  end
end


