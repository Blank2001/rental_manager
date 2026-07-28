json.extract! vehicle, :id, :company_id, :category, :brand, :model, :year, :transmission_type, :fuel_type, :seats, :doors, :daily_rate, :weekly_rate, :monthly_rate, :security_deposit, :security_deposit_applicable, :status, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
