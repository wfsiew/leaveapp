require 'securerandom'

class Admin::UserController < Admin::AdminController

  # GET /user
  # GET /user.json
  def index
    @data = UserHelper.get_all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /user/list
  # GET /user/list.json
  def list
    username = params[:username].blank? ? '' : params[:username]
    role = params[:role].blank? ? 0 : params[:role].to_i
    employee = params[:employee].blank? ? '' : params[:employee]
    status = params[:status].blank? ? 0 : params[:status].to_i
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? UserHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? UserHelper::DEFAULT_SORT_DIR : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    filters = { :username => username,
                :role => role,
                :employee => employee,
                :status => status }
    
    if username.blank? && role == 0 && employee.blank? && status == 0
      @data = UserHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = UserHelper.get_filter_by(filters, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /user/new
  # GET /user/new.json
  def new
    @user = User.new
    @form_id = 'add-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @user }
    end
  end
  
  # POST /user/create
  def create
    status = params[:status]
    status = status == '1' ? true : false
    
    o = User.new(:id => SecureRandom.uuid, :role => params[:role],:username => params[:username], :status => status, :pwd => params[:pwd], :pwd_confirmation => params[:pwdconfirm])
    
    if o.save
      render :json => { :success => 1, :message => 'User was successfully added.' }
      
    else
      render :json => UserHelper.get_errors(o.errors, params)
    end
  end
  
  # GET /user/edit/1
  # GET /user/edit/1.json
  def edit
    @user = User.find(params[:id])
    @form_id = 'edit-form'
    
    respond_to do |fmt|
      fmt.html { render :partial => 'form' }
      fmt.json { render :json => @user }
    end
  end
  
  # POST /user/update
  def update
    o = User.find(params[:id])
    status = params[:status]
    status = status == '1' ? true : false

    if o.update_attributes(:role => params[:role], :username => params[:username], :status => status, :pwd => params[:pwd], :pwd_confirmation => params[:pwdconfirm])
      render :json => { :success => 1, :message => 'User was successfully updated.' }
        
    else
      render :json => UserHelper.get_errors(o.errors, params)
    end
  end
  
  # POST /user/delete
  def destroy
    keyword = params[:keyword].blank? ? '' : params[:keyword]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    ids = params[:id]
    
    User.delete_all(:id => ids)
    
    itemscount = UserHelper.item_message(keyword, pgnum, pgsize)
    
    render :json => { :success => 1, :itemscount => itemscount, :message => "#{ids.size} user(s) was successfully deleted." }
  end
end
