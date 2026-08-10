class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show destroy ]

  # GET /locations or /locations.json
  def index
    if params[:company_id].present?
      @company = Company.friendly.find(params[:company_id])
    else
      respond_to do |format|
        format.html { redirect_to admin_root_path, Alert: "Unable to access that route", status: :see_other }
        format.json { head :no_content }
      end
    end
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  # def new
  #   @location = Location.new
  # end

  # # GET /locations/1/edit
  # def edit
  # end

  # POST /locations or /locations.json
  def create
    @location = Location.new(company_id: params[:company_id].to_i)
     if @location.save(validate: false)
        redirect_to location_build_url(location_id: @location.slug, id: :coordinates)
      else
        redirect_to admin_root, alert: "Failed to initialize location creation."
      end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  # def update
  #   respond_to do |format|
  #     if @location.update(location_params)
  #       format.html { redirect_to @location, notice: "Location was successfully updated.", status: :see_other }
  #       format.json { render :show, status: :ok, location: @location }
  #     else
  #       format.html { render :edit, status: :unprocessable_content }
  #       format.json { render json: @location.errors, status: :unprocessable_content }
  #     end
  #   end
  # end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy!

    respond_to do |format|
      format.html { redirect_to locations_path, notice: "Location was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.expect(location: [ :name, :latitude, :longitude, :is_default, :allows_collection, :allows_return, :hidden ])
    end
end
