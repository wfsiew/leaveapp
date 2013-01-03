class User::LeaveRequestController < User::UserController
  
  # GET /leave/apply
  def index
    leavetypes = LeaveType.order(:name).where(:employee_apply => true)
    @data = leavetypes
    
    render 'index'
  end
  
  # POST /leave/apply
  def create
    _from_date = params[:from_date]
    _to_date = params[:to_date]
      
    from_date = Date.strptime(_from_date, ApplicationHelper.date_fmt) if _from_date.present?
    to_date = Date.strptime(_to_date, ApplicationHelper.date_fmt) if _to_date.present?
      
    id = user_id
    o = Employee.find(id)
    staff_id = o.staff_id
      
    o = LeaveRequest.new(:id => SecureRandom.uuid, :staff_id => staff_id, :leave_type_id => params[:leave_type_id],
                         :day => params[:day], :from_date => from_date, :to_date => to_date, :reason => params[:reason],
                         :day_type => params[:day_type], :status => LeaveRequest::PENDING)
                           
    if o.save
      render :json => { :success => 1, :message => 'Leave was successfully applied.' }
        
    else
      render :json => LeaveRequestHelper.get_errors(o.errors, params)
    end
  end
end
