class User::ReportToController < User::UserController
  
  # GET /reportto
  # GET /reportto.json
  def index
    id = get_employee_id
    o = Employee.find(id)
    @supervisor = o.employee
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @supervisor }
    end
  end
end
