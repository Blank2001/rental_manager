class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit update destroy ]

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
  end

  # GET /reservations/new
  # def new
  #   @reservation = Reservation.new
  # end

  # GET /reservations/1/edit
  # def edit
  # end

  # POST /reservations or /reservations.json
  def create
    # if current_customer.nil?
    #   @reservation = Reservation.new(vehicle_id: params[:vehicle_id].to_i)
    # else
    #   @reservation = Reservation.new(customer_id: current_customer.id, vehicle_id: params[:vehicle_id].to_i)
    # end
    puts params
    # if @reservation.save(validate: false)
    #   redirect_to vehicle_build_url(vehicle_id: @reservation.id, id: :dates)
    # else
    #   redirect_to admin_root, alert: "Failed to initialize reservation creation."
    # end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  # def update
  #   respond_to do |format|
  #     if @reservation.update(reservation_params)
  #       format.html { redirect_to @reservation, notice: "Reservation was successfully updated.", status: :see_other }
  #       format.json { render :show, status: :ok, location: @reservation }
  #     else
  #       format.html { render :edit, status: :unprocessable_content }
  #       format.json { render json: @reservation.errors, status: :unprocessable_content }
  #     end
  #   end
  # end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy!

    respond_to do |format|
      format.html { redirect_to reservations_path, notice: "Reservation was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.expect(reservation: [ :customer_id, :vehicle_id, :collection_date, :return_date, :collection_location, :return_location, :status, :cost ])
    end
end
