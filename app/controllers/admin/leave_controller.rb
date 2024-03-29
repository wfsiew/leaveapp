class Admin::LeaveController < Admin::AdminController
  
  # GET /leave
  # GET /leave.json
  def index
    @data = LeaveRequestHelper.get_all
    @dept = Department.order(:name).all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leave/list
  # GET /leave/list.json
  def list
    _from_date = params[:from_date]
    _to_date = params[:to_date]
    leave_status = params[:leave_status].blank? ? '' : params[:leave_status]
    employee = params[:employee].blank? ? '' : params[:employee]
    dept = params[:dept].blank? ? 0 : params[:dept].to_i
    
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
                :employee => employee,
                :dept => dept }
                
    if from_date.blank? && to_date.blank? && employee.blank? && dept == 0 && leave_status.blank?
      @data = LeaveRequestHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = LeaveRequestHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leave/edit/1
  def edit
    @leave = LeaveRequestHelper::DEFAULT_SORT_DIR.find(params[:id])
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @leave }
    end
  end
  
  # POST /leave/update/1
  def update
    o = LeaveRequest.find(params[:id])
    
    if o.update_attributes(:reason => params[:reason])
      render :json => { :success => 1, :message => 'Leave Reason was successfully updated.' }
      
    else
      render :json => { :success => 0 }
    end
  end
  
  # POST /leave/action/update
  def update_action
    ids = params[:id]
    actions = params[:act]
    id = get_user_id
    count = 0

    ActiveRecord::Base.transaction do
     (0...ids.size).each do |i|
        m = LeaveRequest.find(ids[i])
        LeaveEntitlementHelper.update(ids[i], actions[i])
        
        if actions[i] == LeaveRequest::APPROVED
          n = LeaveRequest.update_all({ :status => actions[i], :approve_by => id, :approve_datetime => Time.now }, ['id = ?', ids[i]])
          
        else
          n = LeaveRequest.update_all({ :status => actions[i] }, ['id = ?', ids[i]])
        end
        
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
