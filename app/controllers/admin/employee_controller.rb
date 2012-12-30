require 'securerandom'

class Admin::EmployeeController < Admin::AdminController
  
  # GET /employee
  # GET /employee.json
  def index
    @data = EmployeeHelper.get_all
    @employmentstatus = EmploymentStatus.order(:name).all
    @designation = Designation.order(:title).all
    @dept = Department.order(:name).all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /employee/list
  # GET /employee/list.json
  def list
    employee = params[:employee].blank? ? '' : params[:employee]
    staff_id = params[:staff_id].blank? ? '' : params[:staff_id]
    employment_status = params[:employment_status].blank? ? 0 : params[:employment_status].to_i
    supervisor = params[:supervisor].blank? ? '' : params[:supervisor]
    designation = params[:designation].blank? ? 0 : params[:designation].to_i
    dept = params[:dept].blank? ? 0 : params[:dept].to_i
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? EmployeeHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? EmployeeHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = { :employee => employee,
                :staff_id => staff_id,
                :employment_status => employment_status,
                :supervisor => supervisor,
                :designation => designation,
                :dept => dept }
                
    if employee.blank? && staff_id.blank? && employment_status == 0 && supervisor.blank? && designation == 0 && dept == 0
      @data = EmployeeHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = EmployeeHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /employee/new
  # GET /employee/new.json
  def new
    @employee = Employee.new
    @form_id = 'add-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @employee }
    end
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  # POST /employee/delete
  def destroy
    employee = params[:employee].blank? ? '' : params[:employee]
    staff_id = params[:staff_id].blank? ? '' : params[:staff_id]
    employment_status = params[:employment_status].blank? ? 0 : params[:employment_status].to_i
    supervisor = params[:supervisor].blank? ? '' : params[:supervisor]
    designation = params[:designation].blank? ? 0 : params[:designation].to_i
    dept = params[:dept].blank? ? 0 : params[:dept].to_i
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    Employee.delete_all(:id => ids)
    
    filters = { :employee => employee,
                :staff_id => staff_id,
                :employment_status => employment_status,
                :supervisor => supervisor,
                :designation => designation,
                :dept => dept }
    
    if employee.blank? && staff_id.blank? && employment_status == 0 && supervisor.blank? && designation == 0 && dept == 0
      itemscount = EmployeeHelper.item_message(nil, pgnum, pgsize)
      
    else
      itemscount = EmployeeHelper.item_message(filters, pgnum, pgsize)
    end
    
    render :json => { :success => 1, :itemscount => itemscount, :message => "#{ids.size} employee(s) was successfully deleted." }
  end
end
