class Reservations::BuildController < ApplicationController
	include Wicked::Wizard
	before_action :validate_viewer

	steps :dates, :collection, :return, :summary #, :payment

	def show
		@reservation = Reservation.friendly.find(params[:reservation_id])
		@reservation.current_step = step.to_s
		if @reservation.res_type == 'maintenance'
			return redirect_to finish_wizard_path
		end
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
			if @reservation.res_type == 'maintenance'
				skip_step
			else
				@reservation.update(reservation_collection_params)
		    end
		when :return
			if @reservation.res_type == 'maintenance'
				skip_step
			elsif @reservation.res_type == 'offline'
				@reservation.update(reservation_return_params)
				@reservation.update({status: 'reserved'})
				return redirect_to finish_wizard_path
			end
		# when :payment
		# 	@reservation.update(reservation_payment_params)
		when :summary
			if @reservation.res_type == 'maintenance'
				@reservation.update({status: 'maintenance'})
				skip_step
			elsif @reservation.res_type == 'offline'
				@reservation.update({status: 'reserved'})
				skip_step	
			else
				@reservation.update({status: "pending"})
			end
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

	    def validate_viewer
			if request.subdomain == "admin"
				if @reservation.vehicle.company.renter_id != current_renter.id
					respond_to do |format|
						format.html { redirect_to root_url, alert: "You do not have permission to view this page", status: :see_other }
						format.json { head :no_content }
					end
				end
			else
				if @reservation.customer_id != current_customer.id
					respond_to do |format|
						format.html { redirect_to root_url, alert: "You do not have permission to view this page", status: :see_other }
						format.json { head :no_content }
					end
				end
			end
	    end
end
