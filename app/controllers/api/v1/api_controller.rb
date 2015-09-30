class API::V1::APIController < ApplicationController
  skip_before_action :verify_authenticity_token

  # When an error occurs, respond with the proper private method below
  rescue_from AuthenticationTimeoutError, with: :authentication_timeout
  rescue_from NotAuthenticatedError, with: :user_not_authenticated

  protected

  def authorize_token
    fail NotAuthenticatedError unless current_api_user.present?
  rescue JWT::ExpiredSignature
    raise AuthenticationTimeoutError
  rescue JWT::VerificationError, JWT::DecodeError
    raise NotAuthenticatedError
  end

  private

  # Authentication Related Helper Methods
  def user_id_included_in_auth_token?
    http_auth_token && decoded_auth_token && decoded_auth_token[:user_id]
  end

  # Decode the authorization header token and return the payload
  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_token)
  end

  # Raw Authorization Header token (json web token format)
  # JWT's are stored in the Authorization header using this format:
  # Bearer somerandomstring.encoded-payload.anotherrandomstring
  def http_auth_token
    @http_auth_token ||= if request.headers['Authorization'].present?
                           request.headers['Authorization'].split(' ').last
                         end
  end

  # Helper Methods for responding to errors
  def authentication_timeout
    render json: { error: 'Authentication Timeout' }, status: 419
  end

  def forbidden_resource
    render json: { error: 'Not Authorized To Access Resource' }, status: :forbidden
  end

  def user_not_authenticated
    render json: { error: 'Not Authenticated' }, status: :unauthorized
  end

  def current_api_user
    if user_id_included_in_auth_token?
      @current_api_user ||= User.find(decoded_auth_token[:user_id])
    end
  end
end
