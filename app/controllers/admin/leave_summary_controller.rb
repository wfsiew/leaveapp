class Admin::LeaveSummaryController < Admin::AdminController
  
  # GET /leavesummary
  # GET /leavesummary.json
  def index
    @data = EmployeeHelper.get_all
    @leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    @designation = Designation.order(:title).all
    @dept = Department.order(:name).all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leavesummary/list
  # GET /leavesummary/list.json
  def list
    employee = params[:employee].blank? ? '' : params[:employee]
    leave_type = params[:leave_type].blank? ? 0 : params[:leave_type].to_i
    designation = params[:designation].blank? ? 0 : params[:designation].to_i
    dept = params[:dept].blank? ? 0 : params[:dept].to_i
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? EmployeeHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? EmployeeHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = { :employee => employee,
                :designation => designation,
                :dept => dept }
    
    if employee.blank? && leave_type == 0 && designation == 0 && dept == 0
      @data = LeaveSummaryHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = LeaveSummaryHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    criteria_leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    
    if leave_type != 0
      criteria_leavetypes = criteria_leavetypes.where(:id => leave_type)
    end
    
    @leavetypes = criteria_leavetypes.all
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => [@data, @leavetypes] }
    end
  end
  
  # POST /leavesummary/create
  def create
    empids = params[:empids]
    leavetypeids = params[:leavetypeids]
    leaveent = params[:leaveent]
    year = Time.now.year
    count = 0
    
    ActiveRecord::Base.transaction do
      (0..empids.size).each do |i|
        o = LeaveEntitlement.where(:id => empids[i], :leave_type_id => leavetypeids[i], :year => year).first
        if o.present?
          n = LeaveEntitlement.update_all({ :day => leaveent[i] }, 
            ['id = ? and leave_type_id = ? and year = ?', empids[i], leavetypeids[i], year])
          if n > 0
            count += 1
          end
        
        else
          o = LeaveEntitlement.new(:id => empids[i], :leave_type_id => leavetypeids[i], :year => year,
                                   :day => leaveent[i], :taken => 0)
          if o.save
            count += 1
          end
        end
      end
    end
    
    if count == empids.size
      render :json => { :success => 1, :message => 'Succesfully saved.' }
      
    else
      render :json => { :error => 1, :message => 'Failed to save.' }
    end
  end
  
end
