class User::MyLeaveController < User::UserController
  
  # GET /leave/own
  def index
    staff_id = get_staff_id
    @data = LeaveRequestHelper.get_all_by_staff_id(staff_id)
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  def list
    _from_date = params[:from_date]
    _to_date = params[:to_date]
    leave_status = params[:leave_status].blank? ? '' : params[:leave_status]
    employee = params[:employee].blank? ? '' : params[:employee]
    staff_id = get_staff_id
    
    from_date = Date.strptime(_from_date, '%d-%m-%Y') if _from_date.present?
    to_date = Date.strptime(_to_date, '%d-%m-%Y') if _to_date.present?
    
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? LeaveRequestHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? LeaveRequestHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = { :from_date => from_date,
                :to_date => to_date,
                :leave_status => leave_status,
                :staff_id => staff_id }
                
    if from_date.blank? && to_date.blank? && leave_status.blank?
      @data = LeaveRequestHelper.get_all_by_staff_id(staff_id, pgnum, pgsize, sort)
      
    else
      @data = LeaveRequestHelper.get_filter_by_staff_id(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leave/own/edit/1
  def edit
    @leave = LeaveRequest.find(params[:id])
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @leave }
    end
  end
  
  # POST /leave/own/update/1
  def update
    o = LeaveRequest.find(params[:id])
    
    if o.update_attributes(:reason => params[:reason])
      render :json => { :success => 1, :message => 'Leave Reason was successfully updated.' }
      
    else
      render :json => { :success => 0 }
    end
  end
  
  # POST /leave/own/action/update
  def update_action
    ids = params[:id]
    actions = params[:act]
    count = 0

    ActiveRecord::Base.transaction do
     (0...ids.size).each do |i|
        m = LeaveRequest.find(ids[i])
        LeaveEntitlementHelper.update(ids[i], actions[i])
        
        n = LeaveRequest.update_all({ :status => actions[i] }, ['id = ?', ids[i]])
        count += 1 if n > 0
      end
    end
    
    if count == ids.size
      render :json => { :success => 1, :message => 'Successfully updated.' }
      
    else
      render :json => { :error => 1, :message => 'Failed to update.' }
    end
  end
end
