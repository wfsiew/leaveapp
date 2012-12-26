class LeaveController < ApplicationController
  layout false
  
  # GET /leave
  # GET /leave.json
  def index
    @data = LeaveHelper.get_all
    
    respond_to do |fmt|
      fmt.html { render 'index', :layout => 'list' }
      fmt.json { render :json => @data }
    end
  end
  
  # GET /leave/list
  # GET /leave/list.json
  def list
    _from_date = params[:from_date]
    _to_date = params[:to_date]
    
    from_date = Date.strptime(_from_date, '%d-%m-%Y') if _from_date.present?
    to_date = Date.strptime(_to_date, '%d-%m-%Y') if _to_date.present?
    
    leave_status = params[:leave_status]
    
    keyword = params[:employee].blank? ? '' : params[:employee]
    pgnum = params[:pgnum].blank? ? 1 : params[:pgnum].to_i
    pgsize = params[:pgsize].blank? ? 0 : params[:pgsize].to_i
    sortcolumn = params[:sortcolumn].blank? ? LeaveHelper::DEFAULT_SORT_COLUMN : params[:sortcolumn]
    sortdir = params[:sortdir].blank? ? LeaveHelper::DEFAULT_SORT_COLUMN : params[:sortdir]
    
    sort = ApplicationHelper::Sort.new(sortcolumn, sortdir)
    
    if _from_date.blank? && _to_date.blank? && keyword.blank?
      @data = LeaveHelper.get_all(pgnum, pgsize, sort)
      
    else
      @data = LeaveHelper.get_filter_by(from_date, to_date, leave_status, employee, pgnum, pgsize, sort)
    end
    
    respond_to do |fmt|
      fmt.html { render :partial => 'list' }
      fmt.json { render :json => @data }
    end
  end
end
