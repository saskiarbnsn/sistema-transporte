class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :load_notifications

  layout :layout_by_resource

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  def load_notifications
    return if devise_controller?

    @notifications = []

    Truck.where("service_kilometres >= ?", 20_000).find_each do |truck|
      @notifications << "Camión #{truck.plate}: #{truck.service_kilometres.to_i} km desde último servicio"
    end

    today = Date.current
    Driver.where("licencia_vencimiento <= ? OR apto_vencimiento <= ?",
                 today + 30, today + 30).find_each do |driver|
      if driver.licencia_vencimiento&.<=(today + 30)
        status = driver.licencia_vencimiento < today ? "vencida" : "vence pronto"
        @notifications << "#{driver.name}: licencia #{status} (#{driver.licencia_vencimiento&.strftime('%d/%m/%Y')})"
      end
      if driver.apto_vencimiento&.<=(today + 30)
        status = driver.apto_vencimiento < today ? "vencido" : "vence pronto"
        @notifications << "#{driver.name}: apto físico #{status} (#{driver.apto_vencimiento&.strftime('%d/%m/%Y')})"
      end
    end
  rescue StandardError
    @notifications = []
  end
end
