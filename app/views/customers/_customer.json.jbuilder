json.extract! customer, :id, :cuit, :name, :created_at, :updated_at
json.url customer_url(customer, format: :json)
