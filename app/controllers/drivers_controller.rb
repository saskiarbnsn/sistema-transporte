class DriversController < ApplicationController
  before_action :set_driver, only: %i[show edit update destroy renew_apto renew_licencia]

  # GET /drivers or /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1 or /drivers/1.json
  def show
    @trips = @driver.trips.includes(:field, :customer, :destination, :truck)
                    .order(date: :desc).limit(50)
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit; end

  # POST /drivers or /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to drivers_url, notice: "Chofer registrado correctamente." }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1 or /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to drivers_url, notice: "Chofer actualizado correctamente." }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_status
    @driver = Driver.find(params[:id])
    @driver.update(aptofisico: false, apto_vencimiento: Date.current)
    @driver.update(licencia_vencimiento: Date.current) if @driver.licencia_vencimiento.nil? || @driver.licencia_vencimiento > Date.current
    render turbo_stream: turbo_stream.replace(
      "driver_status_#{@driver.id}",
      partial: "driver/status_button",
      locals: { driver: @driver }
    )
  end

  # DELETE /drivers/1 or /drivers/1.json
  def destroy
    @driver.destroy

    respond_to do |format|
      format.html { redirect_to drivers_url, notice: "Chofer eliminado." }
      format.json { head :no_content }
    end
  end

  def renew_apto
    has_apto = params[:aptofisico] == "1"
    date = has_apto ? (Date.parse(params[:renewal_date]) rescue nil) : nil
    @driver.update(apto_vencimiento: date, aptofisico: has_apto)
    notice = has_apto ? "Apto físico vigente hasta #{date&.strftime('%d/%m/%Y')}." : "Apto físico marcado como no vigente."
    redirect_back fallback_location: drivers_path, notice: notice
  end

  def renew_licencia
    date = Date.parse(params[:renewal_date]) rescue nil
    @driver.update(licencia_vencimiento: date)
    redirect_back fallback_location: drivers_path, notice: "Licencia renovada hasta #{date&.strftime('%d/%m/%Y')}."
  end

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def driver_params
    params.require(:driver).permit(:name, :birth_date, :phone_number, :location, :cuit, :licencia_vencimiento, :aptofisico, :apto_vencimiento, :latitude, :longitude)
  end
end
