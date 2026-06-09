class TrucksController < ApplicationController
  before_action :set_truck, only: %i[show edit update destroy reset_service]

  # GET /trucks or /trucks.json
  def index
    @trucks = Truck.order(:plate)
  end

  # GET /trucks/1 or /trucks/1.json
  def show
    @trips    = @truck.trips.includes(:field, :customer, :destination, :driver)
                      .order(date: :desc)
    @services = @truck.truck_services.order(service_date: :desc)
    imputation = Imputation.find_by(imputation: "Mantenimiento")
    @maintenance_gastos = Gasto.where(truck: @truck, imputation: imputation).index_by(&:date)
  end

  # GET /trucks/new
  def new
    @truck = Truck.new
  end

  # GET /trucks/1/edit
  def edit; end

  # POST /trucks or /trucks.json
  def create
    @truck = Truck.new(truck_params)

    respond_to do |format|
      if @truck.save
        format.html { redirect_to truck_url(@truck), notice: "Camión registrado correctamente." }
        format.json { render :show, status: :created, location: @truck }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trucks/1 or /trucks/1.json
  def update
    respond_to do |format|
      if @truck.update(truck_params)
        format.html { redirect_to truck_url(@truck), notice: "Camión actualizado correctamente." }
        format.json { render :show, status: :ok, location: @truck }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trucks/1 or /trucks/1.json
  def destroy
    @truck.destroy

    respond_to do |format|
      format.html { redirect_to trucks_url, notice: "Camión eliminado." }
      format.json { head :no_content }
    end
  end

  def reset_service
    date = Date.parse(params[:service_date]) rescue Date.today
    imputation = Imputation.find_by(imputation: "Mantenimiento")

    gasto = Gasto.new(
      truck:       @truck,
      imputation:  imputation,
      date:        date,
      supplier:    params[:supplier].presence,
      description: params[:description].presence,
      total:       params[:total].to_f
    )

    if gasto.save
      @truck.update_column(:service_kilometres, 0)
      redirect_back fallback_location: trucks_path,
        notice: "Servicio registrado el #{date.strftime('%d/%m/%Y')} y cargado en gastos."
    else
      redirect_back fallback_location: trucks_path,
        alert: "Error al registrar: #{gasto.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_truck
    @truck = Truck.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def truck_params
    params.require(:truck).permit(:plate, :brand, :model, :capacity, :fuel, :kilometres, :service_kilometres)
  end
end
