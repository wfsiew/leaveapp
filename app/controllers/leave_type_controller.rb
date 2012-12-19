class LeaveTypeController < ApplicationController
  layout false
  
  # GET /leavetype
  # GET /leavetype.json
  def index
    @data = LeaveTypeHelper.get_all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leavetype/list
  # GET /leavetype/list.json
  def list
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? LeaveTypeHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? LeaveTypeHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    if keyword.blank?
      @data = LeaveTypeHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = LeaveTypeHelper.get_filter_by(keyword, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leavetype/new
  # GET /leavetype/new.json
  def new
    @leavetype = LeaveType.new
    @form_id = 'add-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @leavetype }
    end
  end
  
  # POST /leavetype/create
  def create
    o = LeaveType.new(:name => params[:name], 
                      :admin_adjust => params[:admin_adjust], :admin_assign => params[:admin_assign],
                      :employee_apply => params[:employee_apply])
    
    if o.save
      render :json => { :success => 1, :message => 'Leave Type was successfully added.' }
      
    else
      render :json => LeaveTypeHelper.get_errors(o.errors, params)
    end
  end
  
  # GET /leavetype/edit/1
  # GET /leavetype/edit/1.json
  def edit
    @leavetype = LeaveType.find(params[:id])
    @form_id = 'edit-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @leavetype }
    end
  end
  
  # POST /leavetype/update/1
  def update
    o = LeaveType.find(params[:id])
    
    if o.update_attributes(:name => params[:name], 
                           :admin_adjust => params[:admin_adjust], :admin_assign => params[:admin_assign],
                           :employee_apply => params[:employee_apply])
      render :json => { :success => 1, :message => 'Leave Type was successfully updated.' }
        
    else
      render :json => LeaveTypeHelper.get_errors(o.errors, params)
    end
  end
  
  # POST /leavetype/delete
  def destroy
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    LeaveType.delete_all(:id => ids)
    
    itemscount = LeaveTypeHelper.item_message(keyword, pgnum, pgsize)
    
    render :json => { :success => 1, :itemscount => itemscount, :message => "#{ids.size} Leave Type(s) was successfully deleted." }
  end
end
