class TripsController < ApplicationController
  def index
    @trips = Trip.includes(:field, :customer, :destination, :driver, :truck)
                 .order(date: :desc)
                 .limit(200)
  end

  def show
    @trip = Trip.includes(:field, :customer, :destination, :driver, :truck)
                .find(params[:id])
  end

  def new
    @trip = Trip.new(date: Date.current, estado: true)
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to trips_path, notice: "El viaje se registró correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      redirect_to trip_path(@trip), notice: "El viaje se actualizó correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @trip = Trip.find(params[:id])
    @trip.update(estado: false, date_end: params[:date_end])
    render turbo_stream: turbo_stream.replace(
      "trip_status_#{@trip.id}",
      partial: "trips/status_button",
      locals: { trip: @trip }
    )
  end

  private

  def trip_params
    params.require(:trip).permit(
      :field_id, :customer_id, :destination_id, :driver_id, :truck_id,
      :weight, :product, :date, :date_end, :kilometres, :tariff, :estado,
      :factura, :carta_de_porte
    )
  end
end
