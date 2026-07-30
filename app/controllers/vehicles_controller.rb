class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show destroy photos add_photo reorder_photos]
  before_action :require_renter, except: %i[ show add_photo reorder_photos ]

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

  # GET /vehicles/1/photos
  def photos    
  end

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

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def add_photo
    @photo = Photo.new(photo_params)
    respond_to do |format|
      if @photo.image.attached?
        if @photo.save
          format.html { redirect_to vehicles_path(@photo.vehicle), notice: "Photo was successfully added to #{@photo.vehicle.year} #{@photo.vehicle.brand} #{@photo.vehicle.model}." }
          format.json { render :show, status: :created, location: @photo.vehicle }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @photo.errors, status: :unprocessable_content }
        end
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def reorder_photos
    params[:ids].each_with_index do |id, photo_index|
      @vehicle.photos.find(id).update!(position: photo_index + 1)
    end
    
    head :ok
  end

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
      @vehicle = Vehicle.friendly.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.expect(vehicle: [ :company_id, :category, :brand, :model, :year, :transmission_type, :fuel_type, :seats, :doors, :daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable, :status, :current_step ])
    end

    def photo_params
      params.expect(photo: [ :position, :vehicle_id, :image ])
    end
end
