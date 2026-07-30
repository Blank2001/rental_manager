class Vehicles::BuildController < ApplicationController
	include Wicked::Wizard
	before_action :require_renter

	steps :basics, :specifications, :pricing

	def show
		@vehicle = Vehicle.friendly.find(params[:vehicle_id])
		@vehicle.current_step = step.to_s
		render_wizard
	end

	def update
		if Vehicle.where(slug: params[:vehicle_id]).count == 0
			redirect_to admin_root
		else
			@vehicle = Vehicle.friendly.find(params[:vehicle_id])
		end

		@vehicle.current_step = step.to_s

		case step
		when :basics
			@vehicle.update(vehicle_basic_params)
		when :specifications
			@vehicle.update(vehicle_specifications_params)
		when :pricing
			@vehicle.update(vehicle_pricing_params)
		end

		render_wizard @vehicle
	end

	def create
		@vehicle = Vehicle.create
		redirect_to wizard_path(:basics, vehicle_id: @vehicle.slug)
	end

	def finish_wizard_path
		return @vehicle.company
	end

	private
		def vehicle_basic_params
			params.require(:vehicle).permit(:category, :brand, :model, :year)
		end

		def vehicle_specifications_params
			params.require(:vehicle).permit(:transmission_type, :fuel_type, :seats, :doors)
		end

		def vehicle_pricing_params
			params.require(:vehicle).permit(:daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable)
		end
end
