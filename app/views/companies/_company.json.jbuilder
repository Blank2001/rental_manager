json.extract! company, :id, :renter_id, :name, :address, :country, :email, :phone_number, :created_at, :updated_at
json.url company_url(company, format: :json)
