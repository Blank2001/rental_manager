class StaticPagesController < ApplicationController
  before_action :require_admin, only: %i[ admin_console ]
  before_action :require_renter, only: %i[ renter_console ]
  
  def home
  end
  
  def admin_console
  end

  def renter_console
    @companies = Company.where(renter_id: current_renter)
  end
end