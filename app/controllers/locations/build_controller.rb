class Locations::BuildController < ApplicationController
	include Wicked::Wizard
	before_action :require_renter
	before_action :validate_renter, except: %i[ create ]

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
			if location_coordinates_params[:country].to_s.downcase == @location.company.country.downcase
				@location.update(location_coordinates_params)
			else
				flash[:alert] = "Location must be in the same country as #{@location.company.name}'s country of operation."
				redirect_to wizard_path(:coordinates, location_id: @location.slug) and return
			end
		when :info
			if location_info_params[:is_default] == true
				Location.where(company_id: @location.company.id, is_default: true).each do | location |
					location.update({is_default: false})
				end
			end
			@location.update(location_info_params)
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
		def location_coordinates_params
			params.require(:location).permit(:longitude, :latitude, :city, :country)
		end

		def location_info_params
			params.require(:location).permit(:name, :is_default, :allows_collection, :allows_return, :hidden)
		end

		def validate_renter
			if @vehicle.company.renter_id != current_renter.id
				respond_to do |format|
					format.html { redirect_to root_url, alert: "You do not have permission to view this page", status: :see_other }
					format.json { head :no_content }
				end
			end
		end
end
