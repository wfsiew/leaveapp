class User::InfoController < User::UserController
  
  def index
    id = user_id
    @employee = Employee.find(id)
    
    respond_to do |fmt|
      fmt.html { render 'index' }
      fmt.json { render :json => @employee }
    end
  end
  
  def user_id
    'c259d5e8-04e1-4b93-bf6b-f6c2c4abba29'
  end
end
