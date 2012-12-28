class Admin::LeavePeriodController < Admin::AdminController
  
  # GET /leaveperiod
  # GET /leaveperiod.json
  def index
    months = I18n.t('date.month_names')
    @month_hash = {}
    @day_hash = {}
    current = LeavePeriod.first
    
    (1..12).each do |m|
      @month_hash[months[m]] = m
    end
    
    (1..31).each do |d|
      @day_hash[d] = d
    end
    
    if current.present?
      from_date = current.from_date
      to_date = current.to_date
      @current = "#{from_date.mday}-#{from_date.mon}-#{from_date.year} to #{to_date.mday}-#{to_date.mon}-#{to_date.year}"
    end
    
    respond_to do |fmt|
      fmt.html
    end
  end
  
  # GET /leaveperiod/todate
  def to_date
    _from_date = params[:from_date]
    _from_date = "#{_from_date}-#{Time.now.year}"
    
    begin
      from_date = Date.strptime(_from_date, "%d-%m-%Y")
      to_date = get_to_date(from_date)
      x = Time.new(to_date.year, to_date.mon, to_date.mday, 0, 0, 0)
      @to_date = x.strftime('%B %d')
      @to_date_val = x.strftime('%d-%m-%Y')
    
      render :json => { :to_date => @to_date, :to_date_val => @to_date_val }
      
    rescue Exception => e
      render :json => { :error => 1, :errors => e.message }
    end
  end
  
  def create
    _from_date = params[:from_date]
    _from_date = "#{_from_date}-#{Time.now.year}"
    from_date = Date.strptime(_from_date, "%d-%m-%Y")
    
    _to_date = params[:to_date]
    to_date = Date.strptime(_to_date, "%d-%m-%Y")
    
    o = LeavePeriod.first
    
    if o.blank?
      o = LeavePeriod.new(:from_date => from_date, :to_date => to_date)
      if o.save
        render :json => { :success => 1, :message => 'Leave Period was successfully created.' }
        
      else
        render :json => get_errors(o.errors, params)
      end
      
    else
      if o.update_attributes(:from_date => from_date, :to_date => to_date)
        render :json => { :success => 1, :message => 'Leave Period was successfully updated.' }
        
      else
        render :json => get_errors(o.errors, params)
      end
    end
  end
  
  private
  
  def get_to_date(dt)
    x = 12.month.since(dt)
    y = 1.day.ago(x)
    return y
  end
  
  def get_errors(errors, attr = {})
    { :error => 1, :errors => errors }
  end
end
