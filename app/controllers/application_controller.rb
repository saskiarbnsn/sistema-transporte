class ApplicationController < ActionController::Base
  before_action :auto_login_demo

  def auto_login_demo
    return if user_signed_in?
    sign_in(User.find_by(email: "admin@demo.com"))
  end

  before_action :authenticate_user!
  before_action :load_notifications

  layout :layout_by_resource

  private

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  def load_notifications
    return if devise_controller?

    @notifications = []

    Truck.includes(:trips, :truck_services).find_each do |truck|
      if truck.service_kilometres >= 20_000
        @notifications << { type: :danger, entity: :truck, id: truck.id, msg: "Camión #{truck.plate}: servicio técnico requerido" }
      end
    end

    today = Date.current

    Driver.where(aptofisico: false).find_each do |driver|
      @notifications << { type: :danger, entity: :driver, id: driver.id, msg: "#{driver.name}: sin apto físico" }
    end

    Driver.where("licencia_vencimiento <= ?", today + 30).find_each do |driver|
      status = driver.licencia_vencimiento < today ? "vencida" : "vence pronto"
      @notifications << { type: :warning, entity: :driver, id: driver.id, msg: "#{driver.name}: licencia #{status} (#{driver.licencia_vencimiento.strftime('%d/%m/%Y')})" }
    end

    Driver.where(aptofisico: true).where("apto_vencimiento <= ?", today + 30).find_each do |driver|
      next unless driver.apto_vencimiento
      status = driver.apto_vencimiento < today ? "vencido" : "vence pronto"
      @notifications << { type: :warning, entity: :driver, id: driver.id, msg: "#{driver.name}: apto físico #{status} (#{driver.apto_vencimiento.strftime('%d/%m/%Y')})" }
    end

    @show_notification_badge = @notifications.any?
  rescue StandardError
    @notifications = []
    @show_notification_badge = false
  end
end
