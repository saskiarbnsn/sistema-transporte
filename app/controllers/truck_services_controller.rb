class TruckServicesController < ApplicationController
  before_action :set_truck
  before_action :set_service, only: %i[show edit update destroy]

  def index
    @services = @truck.truck_services
  end

  def show
    @gasto = linked_gasto(@service.service_date)
  end

  def edit
    @gasto = linked_gasto(@service.service_date)
  end

  def update
    @gasto = linked_gasto(@service.service_date)

    ActiveRecord::Base.transaction do
      @service.update!(service_params)
      if @gasto
        @gasto.update!(
          date:        @service.service_date,
          supplier:    params[:gasto][:supplier].presence,
          description: params[:gasto][:description].presence,
          total:       params[:gasto][:total].to_f
        )
      end
    end

    redirect_to truck_truck_services_path(@truck), notice: "Servicio actualizado correctamente."
  rescue ActiveRecord::RecordInvalid => e
    @gasto ||= Gasto.new
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @service.destroy
    redirect_to truck_truck_services_path(@truck), notice: "Servicio eliminado."
  end

  private

  def set_truck
    @truck = Truck.find(params[:truck_id])
  end

  def set_service
    @service = @truck.truck_services.find(params[:id])
  end

  def linked_gasto(date)
    imputation = Imputation.find_by(imputation: "Mantenimiento")
    Gasto.find_by(truck: @truck, date: date, imputation: imputation)
  end

  def service_params
    params.require(:truck_service).permit(:service_date, :kilometres_at_service, :notes)
  end
end
