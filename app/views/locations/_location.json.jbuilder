json.extract! location, :id, :name, :latitude, :longitude, :is_default, :allows_collection, :allows_return, :hidden, :created_at, :updated_at
json.url location_url(location, format: :json)
