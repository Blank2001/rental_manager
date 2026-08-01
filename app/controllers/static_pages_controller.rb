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
        @vehicles = Vehicle.where(id: company_vehicle_ids)
      else
        @vehicles = Vehicle.all
      end
      if params[:search][:collection_date].present? && params[:search][:return_date].present?
        @vehicles = @vehicles.available(params[:search][:collection_date].to_date, params[:search][:return_date].to_date)
        @collection_date = params[:search][:collection_date].to_date
        @return_date = params[:search][:return_date].to_date
      elsif params[:search][:collection_date].present?
        @vehicles = @vehicles.available(params[:search][:collection_date].to_date, params[:search][:collection_date].to_date.tomorrow)
        @collection_date = params[:search][:collection_date].to_date
        @return_date = params[:search][:collection_date].to_date.tomorrow
      elsif params[:search][:return_date].present?
        @vehicles = @vehicles.available(params[:search][:return_date].to_date.yesterday, params[:search][:return_date].to_date)
        @collection_date = params[:search][:return_date].to_date.yesterday
        @return_date = params[:search][:return_date].to_date
      end          
    else
      @vehicles = Vehicle.available(Date.today, Date.tomorrow)
    end
  end
  
  def admin_console
  end

  def renter_console
    @companies = Company.where(renter_id: current_renter)
  end
end