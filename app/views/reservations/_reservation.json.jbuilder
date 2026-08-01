json.extract! reservation, :id, :customer_id, :vehicle_id, :collection_date, :return_date, :collection_location, :return_location, :status, :cost, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
