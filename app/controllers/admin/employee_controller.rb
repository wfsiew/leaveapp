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
    @employee_contact = EmployeeContact.new
    @employee_job = EmployeeJob.new
    @employee_salary = EmployeeSalary.new
    @employee_qualification = EmployeeQualification.new
    @employee_membership = EmployeeMembership.new
    @employee_spouse = EmployeeSpouse.new
    @form_id = 'add-form'
    @users = User.order(:username).all
    @supervisors = Employee.all
    @designations = Designation.order(:title).all
    @employment_statuses = EmploymentStatus.order(:name).all
    @job_categories = JobCategory.order(:name).all
    @departments = Department.order(:name).all
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @employee }
    end
  end
  
  def create
    
  end
  
  # GET /employee/edit/1
  # GET /employee/edit/1.json
  def edit
    @employee = Employee.find(params[:id])
    @employee_contact = @employee.employee_contact.blank? ? EmployeeContact.new : @employee.employee_contact
    @employee_job = @employee.employee_job.blank? ? EmployeeJob.new : @employee.employee_job
    @employee_salary = @employee.employee_salary.blank? ? EmployeeSalary.new : @employee.employee_salary
    @employee_qualification = @employee.employee_qualification.blank? ? EmployeeQualification.new : @employee.employee_qualification
    @employee_membership = @employee.employee_membership.blank? ? EmployeeMembership.new : @employee.employee_membership
    @employee_spouse = @employee.employee_spouse.blank? ? EmployeeSpouse.new : @employee.employee_spouse
    @form_id = 'edit-form'
    @users = User.order(:username).all
    @supervisors = Employee.all
    @designations = Designation.order(:title).all
    @employment_statuses = EmploymentStatus.order(:name).all
    @job_categories = JobCategory.order(:name).all
    @departments = Department.order(:name).all
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @employee }
    end
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
