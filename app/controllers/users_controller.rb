class UsersController < ApplicationController
  layout 'landing'

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, flash: { :'alert-success' => t('user.flash.create.success') }
    else
      flash.now[:'alert-danger'] = t('user.flash.create.failure')
      render :new
    end
  end

  def edit
    @user = current_user
    @notes = current_user.notes.all
    render layout: 'application'
  end

  def update
    @user = current_user
    if @user.update user_params
      redirect_to root_url, flash: { :'alert-success' => t('user.flash.update.success') }
    else
      flash.now[:'alert-danger'] = t('user.flash.update.failure')
      @notes = current_user.notes.all
      render :edit, layout: 'application'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :password, :password_confirmation, :api_key)
  end
end
