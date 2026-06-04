class HomesController < ApplicationController
  def index
    @recent_trips = Trip.includes(:field, :customer, :destination, :driver)
                        .order(date: :desc)
                        .limit(10)

    year = Date.today.year
    range = Date.new(year, 1, 1)..Date.new(year, 12, 31)

    @total_ingresos = Trip.where(date: range).sum(:net)
    @total_gastos   = Gasto.where(date: range).sum(:total)
    @resultado      = @total_ingresos - @total_gastos
    @margen         = @total_ingresos > 0 ? (@resultado / @total_ingresos * 100).round(1) : 0

    @chart_labels   = []
    @chart_ingresos = []
    @chart_gastos   = []
    (1..12).each do |m|
      d = Date.new(year, m, 1)
      r = d..d.end_of_month
      @chart_labels   << d.strftime("%b")
      @chart_ingresos << Trip.where(date: r).sum(:net).round(2)
      @chart_gastos   << Gasto.where(date: r).sum(:total).round(2)
    end
  rescue StandardError
    @recent_trips   = []
    @total_ingresos = @total_gastos = @resultado = @margen = 0
    @chart_labels = @chart_ingresos = @chart_gastos = []
  end
end
