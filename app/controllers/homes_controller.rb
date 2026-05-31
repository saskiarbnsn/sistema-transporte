class HomesController < ApplicationController
  def index
    @recent_trips = Trip.includes(:field, :customer, :destination, :driver)
                        .order(date: :desc)
                        .limit(10)
  rescue StandardError
    @recent_trips = []
  end
end
