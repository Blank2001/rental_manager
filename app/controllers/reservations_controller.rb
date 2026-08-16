class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show destroy ]

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
    if current_customer.nil?
      redirect_to new_customer_session_url, alert: "Please log in to make any reservations."
    else
      @reservation = Reservation.new(reservation_params)
      if @reservation.save
        redirect_to reservation_build_url(reservation_id: @reservation.slug, id: :collection)
      else
        respond_to do |format|
          format.html { redirect_to vehicle_path(@reservation.vehicle, reservation: @reservation.as_json(except: [:created_at, :slug, :updated_at, :id])), alert: @reservation.errors.full_messages.to_sentence, status: :see_other }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      end
    end
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
      params.require(:reservation).permit(:customer_id, :vehicle_id, :collection_date, :return_date, :collection_location, :return_location, :status, :cost, :res_type )
    end
end
