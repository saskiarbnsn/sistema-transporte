class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :load_notifications

  layout :layout_by_resource

  def dismiss_notifications
    session[:notifications_dismissed_digest] = params[:digest]
    head :no_content
  end

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

    Truck.where("service_kilometres >= ?", 20_000).find_each do |truck|
      @notifications << { type: :warning, entity: :truck, msg: "Camión #{truck.plate}: #{truck.service_kilometres.to_i} km desde último servicio" }
    end

    today = Date.current

    Driver.where(aptofisico: false).find_each do |driver|
      @notifications << { type: :danger, entity: :driver, msg: "#{driver.name}: sin apto físico" }
    end

    Driver.where("licencia_vencimiento <= ?", today + 30).find_each do |driver|
      status = driver.licencia_vencimiento < today ? "vencida" : "vence pronto"
      @notifications << { type: :warning, entity: :driver, msg: "#{driver.name}: licencia #{status} (#{driver.licencia_vencimiento.strftime('%d/%m/%Y')})" }
    end

    Driver.where(aptofisico: true).where("apto_vencimiento <= ?", today + 30).find_each do |driver|
      next unless driver.apto_vencimiento
      status = driver.apto_vencimiento < today ? "vencido" : "vence pronto"
      @notifications << { type: :warning, entity: :driver, msg: "#{driver.name}: apto físico #{status} (#{driver.apto_vencimiento.strftime('%d/%m/%Y')})" }
    end

    digest = Digest::MD5.hexdigest(@notifications.map { |n| n[:msg] }.sort.join)
    @notifications_digest = digest
    @show_notification_badge = @notifications.any? && digest != session[:notifications_dismissed_digest]
  rescue StandardError
    @notifications = []
    @show_notification_badge = false
  end
end
