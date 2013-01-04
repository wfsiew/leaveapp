class User::LeaveSummaryController < User::UserController
  
  # GET /leave/summary
  # GET /leave/summary.json
  def index
    @data = get_data
    @leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    @year = Time.now.year
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list_no_nav' }
      fmt.json { render :json => @leavetypes }
    end
  end
  
  # GET /leave/summary/list
  # GET /leave/summary/list.json
  def list
    year = params[:year].blank? ? Time.now.year : params[:year].to_i
    leave_type = params[:leave_type].blank? ? 0 : params[:leave_type].to_i
    @data = get_data
    
    criteria_leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    
    if leave_type != 0
      criteria_leavetypes = criteria_leavetypes.where(:id => leave_type)
    end
    
    @leavetypes = criteria_leavetypes.all
    @year = year
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => [@data, @leavetypes] }
    end
  end
  
  private
  
  def get_data
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = ''
    sortdir = ''
    
    id = user_id
    o = Employee.find(id)
    pager = ApplicationHelper::Pager.new(1, pgnum, pgsize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    
    list = [o]
    @data = { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => 2, :prevpage => 0,
              :list => list, :sortcolumn => sortcolumn, :sortdir => sortdir }
  end
end
