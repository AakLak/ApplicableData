class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :store_current_location, :unless => :devise_controller?

  # private
  # # override the devise helper to store the current location so we can
  # # redirect to it after loggin in or out. This override makes signing in
  # # and signing up work automatically.
  # def store_current_location
  #   store_location_for(:user, request.url)
  # end

end
