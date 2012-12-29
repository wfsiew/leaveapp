module EmployeeHelper
  DEFAULT_SORT_COLUMN = 'staff_id'
  DEFAULT_SORT_DIR = 'ASC'
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    order = sort.to_s
    
    if sort.column == 'd.title' || sort.column == 'es.name' || sort.column == 'dept.name' || sort.column == 'e.first_name'
      criteria = get_join({}, sort)
      
    else
      criteria = Employee
    end
    
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
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
  
  def self.get_filter_by__(find, keyword, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_criteria(find, keyword, sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(:offset => pager.lower_bound, :limit => pager.pagesize)
    { :item_msg => pager.item_message, :hasnext => has_next, :hasprev => has_prev, :nextpage => pagenum + 1, :prevpage => pagenum - 1,
      :list => list, :sortcolumn => sort.column, :sortdir => sort.direction }
  end
  
  def self.get_errors(errors, attr = {})
    m = {}
    { :error => 1, :errors => errors }
  end
  
  def self.item_message(find, keyword, pagenum, pagesize)
    total = 0
    if find == 0 && keyword.blank?
      total = Employee.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
      
    else
      criteria, order = get_filter_criteria(find, keyword)
      total = criteria.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
    end
  end
  
  private
  
  def self.get_filter_criteria(filters, sort = nil)
    employee_keyword = "%#{filters[:employee]}%"
    id_keyword = "%#{filters[:id]}%"
    supervisor_keyword = "%#{filters[:supervisor]}%"
    order = sort.present? ? sort.to_s : nil
    if filters[:employment_status] != 0 || filters[:designation] != 0 || filters[:dept] != 0 ||
      sort.present?
      criteria = get_join(filters, sort)
      
    else
      criteria = Employee
    end
    
    if filters[:employee].present?
      criteria = criteria.where('first_name like ? or middle_name like ? or last_name like ?',
                                 employee_keyword, employee_keyword, employee_keyword)
    end
    
    if filters[:id].present?
      crieria = crieria.where('staff_id like ?', id_keyword)
    end
    
    if filters[:employment_status] != 0
      criteria = crieria.where('es.id = ?', filters[:employment_status])
    end
    
    if filters[:supervisor].present?
      crieria = crieria.where('e.first_name like ? or e.middle_name like ? or e.last_name ?',
                               supervisor_keyword, supervisor_keyword, supervisor_keyword)
    end
    
    return criteria, order
  end
  
  def self.get_filter_criteria__(find, keyword, sort = nil)
    text = "%#{keyword}%"
    order = sort.present? ? sort.to_s : nil
    criteria = Employee
    
    case find
    when 1
      criteria = criteria.where('staff_id like ?', text)
      return criteria, order
      
    when 2
      criteria = criteria.where('first_name like ?', text)
      return criteria, order
      
    when 3
      criteria = crieria.where('middle_name like ?', text)
      return criteria, order
      
    when 4
      criteria = criteria.where('last_name like ?', text)
      return criteria, order
      
    when 5
      criteria = criteria.where('new_ic like ?', text)
      return criteria, order
      
    else
      criteria = criteria.where('staff_id like ? or first_name like ? or middle_name like ? or last_name like ? or new_ic like ?',
                                 text, text, text, text, text)
      return criteria, order
    end
  end
  
  def self.get_join(filters, sort = nil)
    joinhash = {}
    
    if filters.any?
      if filters[:employment_status] != 0
        q = Employee.joins('inner join employee_job ej on employee.id = ej.id')
        .joins('inner join employment_status es on ej.employment_status_id = es.id')
        joinhash[:employment_status] = true
      end

      if filters[:designation] != 0
        if q.blank?
          q = Employee.joins('inner join employee_job ej on employee.id = ej.id')
          .joins('inner join designation d on ej.designation_id = d.id')

        else
          q = q.joins('inner join designation d on ej.designation_id = d.id')
        end

        joinhash[:designation] = true
      end

      if filters[:dept] != 0
        if q.blank?
          q = Employee.joins('inner join employee_job ej on employee.id = ej.id')
          .joins('inner join department dept on ej.department_id = dept.id')

        else
          q = q.joins('inner join department dept on ej.department_id = dept.id')
        end

        joinhash[:dept] = true
      end

      if filters[:supervisor].present?
        if q.blank?
          q = Employee.joins('inner join employee e on employee.id = e.supervisor_id')

        else
          q = q.joins('inner join employee e on employee.id = e.supervisor_id')
        end

        joinhash[:supervisor] = true
      end
    end
    
    if sort.present?
      if sort.column == 'd.title'
        if joinhash.has_key?(:employment_status) && !joinhash.has_key?(:designation)
           q = q.joins('left outer join designation d on ej.designation_id = d.id')
           
        elsif !joinhash.has_key?(:employment_status) && !joinhash.has_key?(:designation)
          if q.blank?
            q = Employee.joins('left outer join employee_job ej on employee.id = ej.id')
                        .joins('left outer join designation d on ej.designation_id = d.id')
                        
          else
            q = q.joins('left outer join employee_job ej on employee.id = ej.id')
                 .joins('left outer join designation d on ej.designation_id = d.id')
          end
        end
      end
      
      if sort.column == 'es.name'
        if !joinhash.has_key?(:employment_status)
          if q.blank?
            q = Employee.joins('left outer join employee_job ej on employee.id = ej.id')
                        .joins('left outer join employment_status es on ej.employment_status_id = es.id')
                        
          else
            q = q.joins('left outer join employee_job ej on employee.id = ej.id')
                 .joins('left outer join employment_status es on ej.employment_status_id = es.id')
          end
        end
      end
    end
    
    if sort.column == 'dept.name'
      if joinhash.has_key?(:employment_status) && !joinhash.has_key?(:dept)
        q = q.joins('left outer join department dept on ej.department_id = dept.id')
        
      elsif !joinhash.has_key?(:employment_status) && !joinhash.has_key?(:dept)
        if q.blank?
          q = Employee.joins('left outer join employee_job ej on employee.id = ej.id')
                      .joins('left outer join department dept on ej.department_id = dept.id')
          
        else
          q = q.joins('left outer join employee_job ej on employee.id = ej.id')
               .joins('left outer join department dept on ej.department_id = dept.id')
        end
      end
    end
    
    if sort.column == 'e.first_name'
      if !joinhash.has_key?(:supervisor)
        if q.blank?
          q = Employee.joins('left outer join employee e on employee.id = e.supervisor_id')
          
        else
          q = q.joins('left outer join employee e on employee.id = e.supervisor_id')
        end
      end
    end
    
    q
  end
end
