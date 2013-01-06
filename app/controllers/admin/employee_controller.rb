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
    @employee_ec_contact = EmployeeEcContact.new
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
  
  # POST /employee/create
  def create
    o = EmployeeHelper.employee_obj(params)
         
    b1 = EmployeeContactHelper.is_empty_params?(params)
    oc = EmployeeContactHelper.employee_contact_obj(o, params)

    b2 = EmployeeEcContactHelper.is_empty_params?(params)          
    oec = EmployeeEcContactHelper.employee_ec_contact_obj(o, params)

    b3 = EmployeeJobHelper.is_empty_params?(params)                         
    oej = EmployeeJobHelper.employee_job_obj(o, params)
           
    b4 = EmployeeSpouseHelper.is_empty_params?(params)               
    osp = EmployeeSpouseHelper.employee_spouse_obj(o, params)
           
    b5 = EmployeeSalaryHelper.is_empty_params?(params)                  
    osa = EmployeeSalaryHelper.employee_salary_obj(o, params)
    
    b6 = EmployeeQualificationHelper.is_empty_params?(params)                          
    oq = EmployeeQualificationHelper.employee_qualification_obj(o, params)
     
    b7 = EmployeeMembershipHelper.is_empty_params?(params)                               
    om = EmployeeMembershipHelper.employee_membership_obj(o, params)
                              
    v1 = o.valid?
    v2 = b1 ? true : oc.valid?
    v3 = b2 ? true : oec.valid?
    v4 = b3 ? true : oej.valid?
    v5 = b4 ? true : osp.valid?
    v6 = b5 ? true : osa.valid?
    v7 = b6 ? true : oq.valid?
    v8 = b7 ? true : om.valid?
    
    if !v1 || !v2 || !v3 || !v4 || !v5 || !v6 || !v7 || !v8
      employee_errors = EmployeeHelper.get_errors(o.errors, params)
      employee_contact_errors = EmployeeContactHelper.get_errors(oc.errors, params)
      employee_ec_contact_errors = EmployeeEcContactHelper.get_errors(oec.errors, params)
      employee_job_errors = EmployeeJobHelper.get_errors(oej.errors, params)
      employee_spouse_errors = EmployeeSpouseHelper.get_errors(osp.errors, params)
      employee_salary_errors = EmployeeSalaryHelper.get_errors(osa.errors, params)
      employee_qualification_errors = EmployeeQualificationHelper.get_errors(oq.errors, params)
      employee_membership_errors = EmployeeMembershipHelper.get_errors(om.errors, params)
      
      errors = { :error => 1, :employee => employee_errors,
                              :employee_contact => employee_contact_errors,
                              :employee_ec_contact => employee_ec_contact_errors,
                              :employee_job => employee_job_errors,
                              :employee_spouse => employee_spouse_errors,
                              :employee_salary => employee_salary_errors,
                              :employee_qualification => employee_qualification_errors,
                              :employee_membership => employee_membership_errors }
      render :json => errors and return
    end
               
    ActiveRecord::Base.transaction do
      o.save
      oc.save if b1
      oec.save if b2
      oej.save if b3
      osp.save if b4
      osa.save if b5
      oq.save if b6
      om.save if b7
    end
    
    render :json => { :success => 1, :message => 'Employee was successfully added.' }
  end
  
  # GET /employee/edit/1
  # GET /employee/edit/1.json
  def edit
    @employee = Employee.find(params[:id])
    @employee_contact = @employee.employee_contact.blank? ? EmployeeContact.new : @employee.employee_contact
    @employee_ec_contact = @employee.employee_ec_contact.blank? ? EmployeeEcContact.new : @employee.employee_ec_contact
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
  
  # POST /employee/update
  def update
    o = Employee.find(params[:id])
    oc = o.employee_contact
    oec = o.employee_ec_contact
    oej = o.employee_job
    osp = o.employee_spouse
    osa = o.employee_salary
    oq = o.employee_qualification
    om = o.employee_membership
    
    oc_new = false
    if oc.blank?
      oc = EmployeeContactHelper.employee_contact_obj(o, params)
      oc_new = true
    end
    
    oec_new = false
    if oec.blank?
      oec = EmployeeEcContactHelper.employee_ec_contact_obj(o, params)
      oec_new = true
    end
    
    oej_new = false
    if oej.blank?
      oej = EmployeeJobHelper.employee_job_obj(o, params)
      oej_new = true
    end
    
    osp_new = false
    if osp.blank?
      osp = EmployeeSpouseHelper.employee_spouse_obj(o, params)
      osp_new = true
    end
    
    osa_new = false
    if osa.blank?
      osa = EmployeeSalaryHelper.employee_salary_obj(o, params)
      osa_new = true
    end
    
    oq_new = false
    if oq.blank?
      oq = EmployeeQualificationHelper.employee_qualification_obj(o, params)
      oq_new = true
    end
    
    om_new = false
    if om.blank?
      om = EmployeeMembershipHelper.employee_membership_obj(o, params)
      om_new = true
    end
    
    b1 = EmployeeContactHelper.is_empty_params?(params)
    b2 = EmployeeEcContactHelper.is_empty_params?(params) 
    b3 = EmployeeJobHelper.is_empty_params?(params)
    b4 = EmployeeSpouseHelper.is_empty_params?(params)
    b5 = EmployeeSalaryHelper.is_empty_params?(params)
    b6 = EmployeeQualificationHelper.is_empty_params?(params)
    b7 = EmployeeMembershipHelper.is_empty_params?(params)
    
    v1 = o.valid?
    v2 = b1 ? true : oc.valid?
    v3 = b2 ? true : oec.valid?
    v4 = b3 ? true : oej.valid?
    v5 = b4 ? true : osp.valid?
    v6 = b5 ? true : osa.valid?
    v7 = b6 ? true : oq.valid?
    v8 = b7 ? true : om.valid?
    
    if !v1 || !v2 || !v3 || !v4 || !v5 || !v6 || !v7 || !v8
      employee_errors = EmployeeHelper.get_errors(o.errors, params)
      employee_contact_errors = EmployeeContactHelper.get_errors(oc.errors, params)
      employee_ec_contact_errors = EmployeeEcContactHelper.get_errors(oec.errors, params)
      employee_job_errors = EmployeeJobHelper.get_errors(oej.errors, params)
      employee_spouse_errors = EmployeeSpouseHelper.get_errors(osp.errors, params)
      employee_salary_errors = EmployeeSalaryHelper.get_errors(osa.errors, params)
      employee_qualification_errors = EmployeeQualificationHelper.get_errors(oq.errors, params)
      employee_membership_errors = EmployeeMembershipHelper.get_errors(om.errors, params)
      
      errors = { :error => 1, :employee => employee_errors,
                              :employee_contact => employee_contact_errors,
                              :employee_ec_contact => employee_ec_contact_errors,
                              :employee_job => employee_job_errors,
                              :employee_spouse => employee_spouse_errors,
                              :employee_salary => employee_salary_errors,
                              :employee_qualification => employee_qualification_errors,
                              :employee_membership => employee_membership_errors }
      render :json => errors and return
    end
    
    ActiveRecord::Base.transaction do
      EmployeeHelper.update_obj(o, params)
      
      if oc_new
        oc.save
        
      else
        EmployeeContactHelper.update_obj(oc, params)
      end
      
      if oec_new
        oec.save
        
      else
        EmployeeEcContactHelper.update_obj(oec, params)
      end
      
      if oej_new
        oej.save
        
      else
        EmployeeJobHelper.update_obj(oej, params)
      end
      
      if osp_new
        osp.save
        
      else
        EmployeeSpouseHelper.update_obj(osp, params)
      end
      
      if osa_new
        osa.save
        
      else
        EmployeeSalaryHelper.update_obj(osa, params)
      end
      
      if oq_new
        oq.save
        
      else
        EmployeeQualificationHelper.update_obj(oq, params)
      end
      
      if om_new
        om.save
        
      else
        EmployeeMembershipHelper.update_obj(om, params)
      end
    end
    
    render :json => { :success => 1, :message => 'Employee was successfully updated.' }
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
