class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def create
    user = User.authenticate(params[:username], params[:password])
    if user.present?
      session[:user_id] = user.id
      if user.role == User::ADMIN
        redirect_to admin_index_path and return
        
      else
        employee = user.employee
        if employee.present?
          session[:employee_id] = employee.id
          session[:staff_id] = employee.staff_id
          session[:supervisor_id] = employee.id
          redirect_to user_index_path and return
          
        else
          flash.now[:alert] = 'No employee record found. Please contact the administrator to create your employee record.'
        end
      end
      
    else
      flash.now[:alert] = 'Incorrect username or password'
    end
    
    render :action => 'new'
  end
  
  def destroy
    reset_session
    redirect_to login_path
  end
  
  protected
  
  def current_user
    return unless session[:user_id]
    @current_user ||= session[:user_id]
  end
  
  def authenticate
    logged_in? ? true : access_denied
  end
  
  def logged_in?
    current_user.present?
  end
  
  def access_denied
    redirect_to login_path, :notice => 'Please log in to continue' and return false
  end
  
  def fmt_date(dt)
    if dt.present?
      dt.strftime('%d-%m-%Y')
    end
  end
  
  def get_user_id
    session[:user_id]
  end
  
  helper_method :current_user
  helper_method :logged_in
  helper_method :fmt_date
end
