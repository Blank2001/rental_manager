class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show destroy ]
  before_action :require_renter

  # GET /vehicles or /vehicles.json
  def index
    @vehicles = Vehicle.all
  end

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  # def new
  #   @vehicle = Vehicle.new
  # end

  # GET /vehicles/1/edit
  # def edit
  # end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(company_id: params[:company_id].to_i)
     if @vehicle.save(validate: false)
        redirect_to vehicle_build_url(vehicle_id: @vehicle.id, id: :basics)
      else
        redirect_to admin_root, alert: "Failed to initialize vehicle creation."
      end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  # def update
  #   respond_to do |format|
  #     if @vehicle.update(vehicle_params)
  #       format.html { redirect_to @vehicle, notice: "Vehicle was successfully updated.", status: :see_other }
  #       format.json { render :show, status: :ok, location: @vehicle }
  #     else
  #       format.html { render :edit, status: :unprocessable_content }
  #       format.json { render json: @vehicle.errors, status: :unprocessable_content }
  #     end
  #   end
  # end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle.destroy!

    respond_to do |format|
      format.html { redirect_to vehicles_path, notice: "Vehicle was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.expect(vehicle: [ :company_id, :category, :brand, :model, :year, :transmission_type, :fuel_type, :seats, :doors, :daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable, :status, :current_step ])
    end
end
