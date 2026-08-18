class StaticPagesController < ApplicationController
  before_action :require_admin, only: %i[ admin_console ]
  before_action :require_renter, only: %i[ renter_console ]
  
  def home
    if !params[:search].nil?
      if params[:search][:location].present?
        company_vehicle_ids = []
        Company.where(country: params[:search][:location]).each do | company |
          company_vehicle_ids += company.vehicles.pluck(:id)
        end
        @vehicles = Vehicle.where(id: company_vehicle_ids, published: true)
      else
        @vehicles = Vehicle.where(published: true)
      end
      if params[:search][:collection_date].present? && params[:search][:return_date].present?
        @vehicles = @vehicles.available(params[:search][:collection_date].to_date, params[:search][:return_date].to_date)
        @collection_date = params[:search][:collection_date].to_date
        @return_date = params[:search][:return_date].to_date
      else
        @vehicles = @vehicles.available_today
      end
      @vehicles = @vehicles.where(transmission_type: params[:search][:transmission_type]) if params[:search][:transmission_type].present?
      @vehicles = @vehicles.where(fuel_type: params[:search][:fuel_type]) if params[:search][:fuel_type].present?
      @vehicles = @vehicles.where('seats >= ?', params[:search][:seats]) if params[:search][:seats].present?
      @vehicles = @vehicles.where('doors >= ?', params[:search][:doors]) if params[:search][:doors].present? 
    else
      @vehicles = Vehicle.available_today
    end
  end
  
  def admin_console
  end

  def renter_console
    @companies = Company.where(renter_id: current_renter)
  end
end