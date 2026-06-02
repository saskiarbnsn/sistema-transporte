class TrucksController < ApplicationController
  before_action :set_truck, only: %i[show edit update destroy]

  # GET /trucks or /trucks.json
  def index
    @trucks = Truck.order(:plate)
  end

  # GET /trucks/1 or /trucks/1.json
  def show
    @trips = @truck.trips.includes(:field, :customer, :destination, :driver)
                   .order(date: :desc).limit(50)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_truck
    @truck = Truck.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def truck_params
    params.require(:truck).permit(:plate, :brand, :model, :capacity, :fuel, :kilometres, :service_kilometres)
  end
end
