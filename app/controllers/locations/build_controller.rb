class Locations::BuildController < ApplicationController
	include Wicked::Wizard
	before_action :require_renter

	steps :coordinates, :info

	def show
		@location = Location.friendly.find(params[:location_id])
		@location.current_step = step.to_s
		render_wizard
	end

	def update
		if Location.where(slug: params[:location_id]).count == 0
			redirect_to root
		else
			@location = Location.friendly.find(params[:location_id])
		end

		@location.current_step = step.to_s

		case step
		when :coordinates
			@location.update(reservation_coordinates_params)
		when :info
			@location.update(reservation_info_params)
		end

		render_wizard @location
	end

	def create
		@location = Location.create
		redirect_to wizard_path(:coordinates, location_id: @location.slug)
	end

	def finish_wizard_path
		return locations_path(company_id:@location.company.slug)
	end

	private
		def reservation_coordinates_params
			params.require(:location).permit(:longitude, :latitude, :city, :country)
		end

		def reservation_info_params
			params.require(:location).permit(:name, :is_default, :allows_collection, :allows_return, :hidden)
		end
end
