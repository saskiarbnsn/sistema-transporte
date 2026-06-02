class GastosController < ApplicationController
  before_action :set_gasto, only: %i[show edit update destroy]

  def index
    @year  = params[:year]&.to_i  || Date.today.year
    @month = params[:month]&.to_i || Date.today.month

    range = Date.new(@year, @month, 1)..Date.new(@year, @month, -1)

    @gastos = Gasto.includes(:imputation, :driver, :truck)
                   .where(date: range)
                   .order(date: :desc)

    @total_gastos   = @gastos.sum(:total)
    @total_ingresos = Trip.where(date: range).sum(:net)
    @resultado      = @total_ingresos - @total_gastos
    @margen         = @total_ingresos > 0 ? (@resultado / @total_ingresos * 100).round(1) : 0

    @por_categoria = @gastos.joins(:imputation)
                            .group("imputations.imputation")
                            .sum(:total)
                            .sort_by { |_, v| -v }

    @chart_labels   = []
    @chart_ingresos = []
    @chart_gastos   = []
    12.downto(0) do |i|
      d = Date.today.beginning_of_month - i.months
      r = d..d.end_of_month
      @chart_labels   << d.strftime("%b %Y")
      @chart_ingresos << Trip.where(date: r).sum(:net).round(2)
      @chart_gastos   << Gasto.where(date: r).sum(:total).round(2)
    end
  end

  def show; end

  def new
    @gasto = Gasto.new(date: Date.today)
    @imputations = Imputation.order(:imputation)
  end

  def create
    @gasto = Gasto.new(gasto_params)
    if @gasto.save
      redirect_to gastos_path, notice: "Gasto registrado correctamente."
    else
      @imputations = Imputation.order(:imputation)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @imputations = Imputation.order(:imputation)
  end

  def update
    if @gasto.update(gasto_params)
      redirect_to gastos_path, notice: "Gasto actualizado correctamente."
    else
      @imputations = Imputation.order(:imputation)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gasto.destroy
    redirect_to gastos_path, notice: "Gasto eliminado."
  end

  private

  def set_gasto
    @gasto = Gasto.find(params[:id])
  end

  def gasto_params
    params.require(:gasto).permit(
      :imputation_id, :supplier, :description,
      :driver_id, :truck_id, :date, :total,
      :truck_disabled, :driver_disabled
    )
  end
end
