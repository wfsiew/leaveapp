class User::LeaveCalendarController < User::UserController
  
  def index
    @data = []
    
    respond_to do |fmt|
      fmt.html
      fmt.json { render :json => @data }
    end
  end
  
  def data
    start_time = Time.at(params[:start].to_i)
    end_time = Time.at(params[:end].to_i)
    start_date = start_time.to_date
    end_date = end_time.to_date
    
    @data = get_leave(start_date, end_date)
    
    render :json => @data
  end
  
  def get_leave(start_date, end_date)
    criteria = LeaveRequest
    criteria = criteria.where(:status => LeaveRequest::APPROVED)
    criteria = criteria.where('from_date >= ? and from_date < ?', start_date, end_date)
    list = criteria.all
    o = []
    list.each do |x|
      e = x.employee
      leave_type = x.leave_type
      title = "#{e.first_name} #{e.middle_name} #{e.last_name} (#{leave_type.name} Leave)"
      if x.day_type == 1
        title += " (Half day morning)"
        
      elsif x.day_type == 2
        title += " (Half day afternoon)"
      end
      o << {
        :title => title,
        :start => x.from_date.to_s,
        :end => x.to_date.to_s
      }
    end
    
    o
  end
end
