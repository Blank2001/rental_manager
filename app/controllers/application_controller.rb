class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_admin, if: :admin_found?
  before_action :set_renter, if: :renter_found?
  before_action :set_customer, if: :customer_found?
  before_action :set_meta
  
  def set_customer
    customer = Customer.find(current_customer['id'])
    current_customer = customer
  end

  def customer_found?
    !current_customer.nil?
  end

  def customer_present?
    if !current_customer.nil?
        return true
    else
        return false
    end
  end

  def set_renter
    renter = Renter.find(current_renter['id'])
    current_renter = renter
  end

  def renter_found?
    !current_renter.nil?
  end

  def renter_present?
    if !current_renter.nil?
        return true
    else
        return false
    end
  end

  def set_admin
    admin = Admin.find(current_admin['id'])
    current_admin = admin
  end

  def admin_found?
    !current_admin.nil?
  end

  def admin_present?
    if !current_admin.nil?
        return true
    else
        return false
    end
  end

  def set_meta
    @title = "Get your rental today."
    @description = "Browse available rentals. This web app is brought to you by Kinexia Inc. based in Montserrat."
    @keywords = "Rentals, Cars, Caribbean"    
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit( :first_name, :last_name, :contact_number, :email, :password, :password_confirmation ) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit( :first_name, :last_name, :contact_number, :email, :password, :password_confirmation, :current_password, :signature )}
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password)}
    devise_parameter_sanitizer.permit(:select_privileges) { |u| u.permit( :privileges) }
  end

  private
    def require_admin
      if current_admin.nil?
        redirect_to new_admin_session_url(subdomain: "console")
      end
    end
    
    def require_renter
      if current_renter.nil?
        redirect_to new_renter_session_url(subdomain: "admin")
      end
    end
end
