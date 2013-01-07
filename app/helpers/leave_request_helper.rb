module LeaveRequestHelper
  DEFAULT_SORT_COLUMN = 'from_date'
  DEFAULT_SORT_DIR = 'DESC'
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria = LeaveRequest.where(:status => LeaveRequest::PENDING)
    total = LeaveRequest.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_filter_by(filters, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_criteria(filters, sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_errors(errors, attr = {})
    { :error => 1, :errors => errors }
  end
  
  def self.get_all_by_staff_id(staff_id, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria = LeaveRequest.where(:staff_id => staff_id, :status => LeaveRequest::PENDING)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_filter_by_staff_id(filters, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_by_staff_id_criteria(filters, sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_all_by_supervisor_id(supervisor_id, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria = LeaveRequest.where(:status => LeaveRequest::PENDING)
    criteria = get_join_employee(criteria)
    criteria = criteria.where('e.supervisor_id = ?', supervisor_id)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_filter_by_supervisor_id(filters, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_by_supervisor_id_criteria(filters, sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  private
  
  def self.get_filter_criteria(filters, sort = nil)
    employee_keyword = "%#{filters[:employee]}%"
    order = sort.present? ? sort.to_s : nil
    if filters[:employee].present? || filters[:dept] != 0
      criteria = get_join(filters)
      
    else
      criteria = LeaveRequest
    end
    
    if filters[:from_date].present?
      criteria = criteria.where('from_date >= ?', filters[:from_date])
    end
    
    if filters[:to_date].present?
      criteria = criteria.where('to_date <= ?', filters[:to_date])
    end
    
    if filters[:leave_status].present?
      criteria = criteria.where('status in (?)', filters[:leave_status])
    end
    
    if filters[:employee].present?
      criteria = criteria.where('e.first_name like ? or e.middle_name like ? or e.last_name like ?',
                                 employee_keyword, employee_keyword, employee_keyword)
    end
    
    if filters[:dept] != 0
      criteria = criteria.where('dept.id = ?', filters[:dept])
    end
    
    return criteria, order
  end
  
  def self.get_join_employee(criteria)
    criteria.joins('inner join employee e on leave_request.staff_id = e.staff_id')
  end
  
  def self.get_join(filters)
    if filters[:employee].present?
      q = LeaveRequest.joins('inner join employee e on leave_request.staff_id = e.staff_id')
    end
    
    if filters[:dept] != 0
      if q.blank?
        q = LeaveRequest.joins('inner join employee e on leave_request.staff_id = e.staff_id')
                        .joins('inner join employee_job ej on e.id = ej.id')
                        .joins('inner join department dept on ej.department_id = dept.id')
        
      else
        q = q.joins('inner join employee_job ej on e.id = ej.id')
             .joins('inner join department dept on ej.department_id = dept.id')
      end
    end
    
    q
  end
  
  def self.get_filter_by_staff_id_criteria(filters, sort = nil)
    order = sort.present? ? sort.to_s : nil
    criteria = LeaveRequest
    
    if filters[:from_date].present?
      criteria = criteria.where('from_date >= ?', filters[:from_date])
    end
    
    if filters[:to_date].present?
      criteria = criteria.where('to_date <= ?', filters[:to_date])
    end
    
    if filters[:leave_status].present?
      criteria = criteria.where('status in (?)', filters[:leave_status])
    end
    
    if filters[:staff_id].present?
      criteria = criteria.where(:staff_id => filters[:staff_id])
    end
    
    return criteria, order
  end
  
  def self.get_filter_by_supervisor_id_criteria(filters, sort = nil)
    employee_keyword = "%#{filters[:employee]}%"
    order = sort.present? ? sort.to_s : nil
    criteria = get_join_employee(LeaveRequest)
    
    criteria = criteria.where('e.supervisor_id = ?', filters[:supervisor_id])
    
    if filters[:from_date].present?
      criteria = criteria.where('from_date >= ?', filters[:from_date])
    end
    
    if filters[:to_date].present?
      criteria = criteria.where('to_date <= ?', filters[:to_date])
    end
    
    if filters[:leave_status].present?
      criteria = criteria.where('status in (?)', filters[:leave_status])
    end
    
    if filters[:employee].present?
      criteria = criteria.where('e.first_name like ? or e.middle_name like ? or e.last_name like ?',
                                 employee_keyword, employee_keyword, employee_keyword)
    end
    
    return criteria, order
  end
end
