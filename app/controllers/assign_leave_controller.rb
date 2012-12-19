require 'securerandom'

class AssignLeaveController < ApplicationController
  layout false
  
  # GET /asgnleave
  # GET /asgnleave.json
  def index
    leavetypes = LeaveType.order(:name).where(:admin_assign => true)
    @data = leavetypes
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @data }
    end
  end
  
  # POST /asgnleave/create
  def create
    _from_date = params[:from_date]
    _to_date = params[:to_date]
    
    from_date = Date.strptime(_from_date, '%d-%m-%Y') if _from_date.present?
    to_date = Date.strptime(_to_date, '%d-%m-%Y') if _to_date.present?
    
    o = Leave.new(:id => SecureRandom.uuid, :employee_id => params[:employee_id], :leave_type_id => params[:leave_type_id],
                  :day => params[:day], :from_date => from_date, :to_date => to_date, :reason => params[:reason])
                  
    if o.save
      render :json => { :success => 1, :message => 'Leave was successfully assigned.' }
      
    else
      render :json => LeaveHelper.get_errors(o.errors, params)
    end
  end
end
