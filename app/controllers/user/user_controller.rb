class User::UserController < ApplicationController
  layout false
  
  before_filter :authenticate_normal_user
  
  #employee id
  def user_id
    'c259d5e8-04e1-4b93-bf6b-f6c2c4abba29'
    #'b3ea0d6e-75d1-4d42-a0fb-86465c2d9fbb'
  end
  
  def get_staff_id
    'S0002'
  end
  
  def supervisor_id
    'd9c2ab85-f233-4359-ace7-a02679ab4293'
  end
  
  def logged_in_id
    '180b0a04-bb21-4489-893d-d8939a114806'
  end
  
  def normal_user
    return unless session[:employee_id]
    @normal_user ||= session[:employee_id]
  end
  
  def authenticate_normal_user
    unless authenticate
      return false
    end
    logged_in_normal_user? ? true : access_denied
  end
  
  def logged_in_normal_user?
    normal_user.present?
  end
  
  helper_method :normal_user
  helper_method :logged_in_normal_user
end
