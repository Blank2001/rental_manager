module ApplicationHelper
	def format_date_range(start_date, end_date)
		return if start_date.nil? || end_date.nil?

		start_date = start_date.to_date
		end_date = end_date.to_date
		en_dash = "–"

		if start_date.month == end_date.month && start_date.year == end_date.year
			"#{start_date.strftime('%b %e').strip}#{en_dash}#{end_date.strftime('%e').strip}, #{end_date.year}"
		elsif start_date.year == end_date.year
			"#{start_date.strftime('%b %e').strip}#{en_dash}#{end_date.strftime('%b %e').strip}, #{end_date.year}"
		else
			"#{start_date.strftime('%b %e, %Y').strip}#{en_dash}#{end_date.strftime('%b %e, %Y').strip}"
		end
	end
end
