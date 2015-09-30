class API::V2::SessionsController < API::V2::APIController

  def create
    user = User.find_by username: user_params[:username]
    if user.present? && user.authenticate(user_params[:password])
      render json: authentication_payload(user)
    else
      render json: { error: t('session.flash.create.failure') }, status: :unprocessable_entity
    end
  end

  private

  def authentication_payload(user)
    return nil unless user && user.id
    {
      auth_token: AuthToken.encode({ user_id: user.id }),
      user: user.attributes.slice('id', 'username', 'name', 'created_at', 'updated_at')
    }
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
