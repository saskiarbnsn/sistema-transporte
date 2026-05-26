json.extract! destination, :id, :cuit, :name, :location, :city, :province, :created_at, :updated_at
json.url destination_url(destination, format: :json)
