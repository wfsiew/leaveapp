class User::SpouseController < User::UserController
  
  # GET /spouse
  # GET /spouse.json
  def index
    id = user_id
    @employee_spouse = EmployeeSpouse.find(id)
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @employee_contact }
    end
  end
  
  # POST /spouse/update
  def update
    id = user_id
    osp = EmployeeSpouse.find(id)
    
    osp_new = false
    if osp.blank?
      o = Employee.find(id)
      osp = EmployeeSpouseHelper.employee_spouse_obj(o, params)
      osp_new = true
    end
    
    if osp_new
      if osp.save
        render :json => { :success => 1, :message => 'Spouse Details was successfully updated.' }
        
      else
        render :json => EmployeeSpouseHelper.get_errors(osp.errors, params)
      end
      
    else
      if EmployeeSpouseHelper.update_obj(osp, params)
        render :json => { :success => 1, :message => 'Spouse Details was successfully updated.' }
        
      else
        render :json => EmployeeSpouseHelper.get_errors(osp.errors, params)
      end
    end
  end
end
