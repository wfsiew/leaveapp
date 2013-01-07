class User::MembershipController < User::UserController
  
  # GET /membership
  # GET /membership.json
  def index
    id = get_employee_id
    @employee_membership = EmployeeMembershipHelper.find(id)
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @employee_membership }
    end
  end
  
  # POST /membership/update
  def update
    id = get_employee_id
    om = EmployeeMembershipHelper.find(id)
    
    om_new = false
    if om.blank?
      o = Employee.find(id)
      om = EmployeeMembershipHelper.employee_membership_obj(o, params)
      om_new = true
    end
    
    if om_new
      if om.save
        render :json => { :success => 1, :message => 'Membership Details was successfully updated.' }
        
      else
        render :json => EmployeeMembershipHelper.get_errors(om.errors, params)
      end
      
    else
      if EmployeeMembershipHelper.update_obj(om, params)
        render :json => { :success => 1, :message => 'Membership Details was successfully updated.' }
        
      else
        render :json => EmployeeMembershipHelper.get_errors(om.errors, params)
      end
    end
  end
end
