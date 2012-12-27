var leave = ( function() {
    var url = {
      list : '/leave/list/'
    };

    function func_save() {
      alert('save')
    }

    function get_search_param() {
      var param = {
        from_date : $('#id_from_date').val(),
        to_date : $('#id_to_date').val(),
        employee : encodeURIComponent($('#id_employee').val()),
        dept : $('#id_dept').val(),
        'leave_status[]' : get_leave_status()
      };
      
      return param;
    }
    
    function get_leave_status() {
      var a = [];
      if (is_checked('#id_all'))
        a = ['P', 'A', 'R', 'C'];
        
      else {
        if (is_checked('#id_rejected'))
          a.push('R');
          
        if (is_checked('#id_canceled'))
          a.push('C');
          
        if (is_checked('#id_pending'))
          a.push('P')
          
        if (is_checked('#id_approved'))
          a.push('A');
      }
        
      return a;
    }
    
    function is_checked(id) {
      if ($(id).attr('checked') == 'checked')
        return true;
        
      return false;
    }

    function check_all_status() {
      var a = $(this).attr('checked');
      if (a == 'checked')
        $('.chkstatus').attr('checked', 'checked');
      
      else
        $('.chkstatus').removeAttr('checked');
    }

    function init() {
      $('#id_from_date,#id_to_date').datepicker({
        dateFormat : utils.date_format,
        changeMonth : true,
        changeYear : true
      });
      $('#id_find').click(nav_list.show_list);
      $('#id_employee').tooltip({track: true});
      $('.chkall').click(check_all_status);
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_save,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.save_func = func_save;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }

    function load() {
      return menu.get('/leave/', init);
    }

    return {
      load : load
    };
}());