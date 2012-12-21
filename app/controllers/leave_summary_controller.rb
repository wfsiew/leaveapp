class LeaveSummaryController < ApplicationController
  layout false
  
  # GET /leavesummary
  # GET /leavesummary.json
  def index
    @data = EmployeeHelper.get_all
    @leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leavesummary/list
  # GET /leavesummary/list.json
  def list
    find = params[:find].blank? ? 0 : params[:find].to_i
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? EmployeeHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? EmployeeHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    if find == 0 && keyword.blank?
      @data = EmployeeHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = EmployeeHelper.get_filter_by(find, keyword, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
end
