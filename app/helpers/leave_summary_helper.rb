module LeaveSummaryHelper
  def self.get_employee_leave_entitlement(empid, leavetype, year)
    m = { :day =>  0.00, :balance => 0.00, :taken => 0.00 }
    o = LeaveEntitlement.where(:id => empid, :leave_type_id => leavetype, :year => year).first
    if o.present?
      balance = o.day - o.taken
      m = { :day => o.day, :balance => balance, :taken => o.taken }
    end
    
    m
  end
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    EmployeeHelper.get_all(pagenum, pagesize, sort)
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
  
  private
  
  def self.get_filter_criteria(filters, sort = nil)
    employee_keyword = "%#{filters[:employee]}%"
    order = sort.present? ? sort.to_s : nil
    if filters[:designation] != 0 || filters[:dept] != 0
      criteria = get_join(filters)
      
    else
      criteria = Employee
    end
    
    if filters[:employee].present?
      criteria = criteria.where('first_name like ? or middle_name like ? or last_name like ?',
                                 employee_keyword, employee_keyword, employee_keyword)
    end
    
    if filters[:designation] != 0
      criteria = criteria.where('d.id = ?', filters[:designation])
    end
    
    if filters[:dept] != 0
      criteria = criteria.where('dept.id = ?', filters[:dept])
    end
    
    return criteria, order
  end
  
  def self.get_join(filters)
    q = nil
    if filters[:designation] != 0
      q = Employee.joins('inner join employee_job ej on employee.id = ej.id')
                  .joins('inner join designation d on ej.designation_id = d.id')
    end
    
    if filters[:dept] != 0
      if q.blank?
        q = Employee.joins('inner join employee_job ej on employee.id = ej.id')
                    .joins('inner join department dept on ej.department_id = dept.id')
      
      else
        q = q.joins('inner join department dept on ej.department_id = dept.id')
      end
    end
    
    q
  end
end
