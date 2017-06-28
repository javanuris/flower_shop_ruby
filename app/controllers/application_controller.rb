class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  helper_method :current_order

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end
  
  def check_admin
   redirect_to root_url unless current_user && current_user.admin?
  end
  
end
