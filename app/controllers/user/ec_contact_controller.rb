class User::EcContactController < User::UserController
  
  # GET /eccontact
  # GET /eccontact.json
  def index
    id = get_employee_id
    @employee_ec_contact = EmployeeEcContactHelper.find(id)
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @employee_ec_contact }
    end
  end
  
  # POST /eccontact/update
  def update
    id = get_employee_id
    oec = EmployeeEcContactHelper.find(id)
    
    oec_new = false
    if oec.blank?
      o = Employee.find(id)
      oec = EmployeeEcContactHelper.employee_ec_contact_obj(o, params)
      oec_new = true
    end
    
    if oec_new
      if oec.save
        render :json => { :success => 1, :message => 'Emergency Contact was successfully updated.' }
        
      else
        render :json => EmployeeEcContactHelper.get_errors(oec.errors, params)
      end
      
    else
      if EmployeeEcContactHelper.update_obj(oec, params)
        render :json => { :success => 1, :message => 'Emergency Contact was successfully updated.' }
        
      else
        render :json => EmployeeEcContactHelper.get_errors(oec.errors, params)
      end
    end
  end
end
