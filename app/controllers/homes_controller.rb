class HomesController < ApplicationController
  def index
    @recent_drivers = Driver.order(created_at: :desc).limit(5)
  end
end
