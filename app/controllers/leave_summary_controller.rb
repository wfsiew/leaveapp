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
    
    @leavetypes = LeaveType.order(:name).where(:admin_adjust => true)
    
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
