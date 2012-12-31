class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :fmt_date
  
  def fmt_date(dt)
    if dt.present?
      dt.strftime('%d-%m-%Y')
    end
  end
end
