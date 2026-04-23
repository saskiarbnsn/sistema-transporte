class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    @customers_count = Customer.count
    @drivers_count = Driver.count
    @trucks_count = Truck.count
    @destinations_count = Destination.count

    @recent_customers = Customer.order(created_at: :desc).limit(5)
    @recent_drivers = Driver.order(created_at: :desc).limit(5)
    @recent_trucks = Truck.order(created_at: :desc).limit(5)
    @recent_destinations = Destination.order(created_at: :desc).limit(5)
  end
end