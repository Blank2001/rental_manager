class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show destroy photos add_photo reorder_photos publish hide ]
  before_action :require_renter, except: %i[ destroy photos add_photo reorder_photos publish hide ]
  before_action :validate_renter, only: %i[ destroy photos add_photo reorder_photos publish hide ]
  before_action :validate_published, only: %i[ show ]

  # GET /vehicles or /vehicles.json
  # def index
  #   @vehicles = Vehicle.all
  # end

  # GET /vehicles/1 or /vehicles/1.json
  def show
    if current_customer.nil?
      @reservation = Reservation.new(vehicle_id: @vehicle.id, collection_date: ((params[:search].nil? || params[:search][:collection_date].nil?) ? Date.today : params[:search][:collection_date]), return_date: ((params[:search].nil? || params[:search][:return_date].nil?) ? Date.today.next_day(@vehicle.minimum_days) : params[:search][:return_date]), res_type: "online")
    elsif request.subdomain != "admin" || request.subdomain != "console"
      if params[:reservation_id].present?
        @reservation = Reservation.friendly.find(params[:reservation_id])
        if params[:reservation].present?
          @reservation.update(reservation_params)
        end
      elsif params[:reservation].present?
        @reservation = Reservation.new(reservation_params)
      else
        @reservation = Reservation.new(customer_id: current_customer.id, vehicle_id: @vehicle.id, collection_date: (params[:search][:collection_date].nil? ? Date.today : params[:search][:collection_date]), return_date: (params[:search][:return_date].nil? ? Date.today.next_day(@vehicle.minimum_days) : params[:search][:return_date]))
      end
    end
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
        redirect_to vehicle_build_url(vehicle_id: @vehicle.slug, id: :basics)
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

  def publish
    if @vehicle.photos.count >= 5
      @vehicle.update({published: true})
      respond_to do |format|
        format.html { redirect_to vehicles_path(@vehicle), notice: "#{@vehicle.year} #{@vehicle.brand} #{@vehicle.model} was published", status: :see_other }
        format.json { render :show, status: :ok, location: @vehicle }
      end
    else
      respond_to do |format|
        format.html { redirect_to vehicles_path(@vehicle), alert: "Add #{5 - @vehicle.photos.count} #{(5 - @vehicle.photos.count) == 1 ? "photo" : "photo".pluralize} to #{@vehicle.year} #{@vehicle.brand} #{@vehicle.model} before publishing", status: :see_other }
      format.json { head :no_content }
      end
    end
  end

  def hide
    @vehicle.update({published: false})
    respond_to do |format|
      format.html { redirect_to vehicles_path(@vehicle), notice: "#{@vehicle.year} #{@vehicle.brand} #{@vehicle.model} was hidden from the public", status: :see_other }
      format.json { render :show, status: :ok, location: @vehicle }
    end
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
      params.expect(vehicle: [ :company_id, :category, :brand, :model, :year, :transmission_type, :fuel_type, :seats, :doors, :minimum_days, :daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable, :status, :current_step, :published ])
    end

    def photo_params
      params.expect(photo: [ :position, :vehicle_id, :image ])
    end
    
    def reservation_params
      params.expect(reservation: [ :customer_id, :vehicle_id, :collection_date, :return_date, :collection_location, :return_location, :status, :cost, :res_type ])
    end

    def validate_renter
      if @vehicle.company.renter_id != current_renter.id
        respond_to do |format|
          format.html { redirect_to root_url, alert: "You do not have permission to view this page", status: :see_other }
          format.json { head :no_content }
        end
      end
    end

    def validate_published
      if request.subdomain != "admin" && !@vehicle.published
        respond_to do |format|
          format.html { redirect_to root_url, alert: "This vehicle is not available", status: :see_other }
          format.json { head :no_content }
        end
      end
    end
end
