class Reservations::BuildController < ApplicationController
	include Wicked::Wizard

	steps :dates, :collection, :return, :summary #, :payment

	def show
		@reservation = Reservation.friendly.find(params[:reservation_id])
		@reservation.current_step = step.to_s
		render_wizard
	end

	def update
		if Reservation.where(slug: params[:reservation_id]).count == 0
			redirect_to root
		else
			@reservation = Reservation.friendly.find(params[:reservation_id])
		end

		@reservation.current_step = step.to_s

		case step
		when :dates
			@reservation.update(reservation_dates_params)
		when :collection
			@reservation.update(reservation_collection_params)
		when :return
			@reservation.update(reservation_return_params)
		# when :payment
		# 	@reservation.update(reservation_payment_params)
		when :summary
			@reservation.update({status: "pending"})
		end

		render_wizard @reservation
	end

	def create
		@reservation = Reservation.create
		redirect_to wizard_path(:dates, reservation_id: @reservation.slug)
	end

	def finish_wizard_path
		return @reservation
	end

	private
		def reservation_dates_params
			params.require(:reservation).permit(:collection_date, :return_date, :res_type)
		end

		def reservation_collection_params
			params.fetch(:reservation, {}).permit(:collection_location)
		end

		def reservation_return_params
			params.fetch(:reservation, {}).permit(:return_location)
		end

		# def reservation_payment_params
		# 	params.require(:reservation).permit(:daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable)
		# end
end
