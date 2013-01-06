class Admin::AdminController < ApplicationController
  layout false
  
  before_filter :authenticate
  
  def logged_in_id
    '180b0a04-bb21-4489-893d-d8939a114806'
  end
end
