# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @title = "Log in"
    @description = "Log in to get your rental now! Access avaialable rentals in Caribbean Islands with Caribbean Rentals. Browse various rental companies and their rentals. This web app is brought to you by Kinexia Inc. based in Montserrat."
    @keywords = "Sign In, Log In, Vehicle Rentals, Caribbean Rentals" 
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
