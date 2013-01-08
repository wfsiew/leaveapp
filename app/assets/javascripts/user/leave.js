var leave = ( function() {
    var url = {
      update_action : '/user/leave/action/update/',
      list : '/user/leave/list/'
    };
    
    function func_save() {
      var a = [];
      var b = [];
      $('.leaveaction').each(function(idx, elm) {
        var x = $(this).val();
        var id = $(this).parent().parent().attr('id');
        id = utils.get_itemid(id);
        if (x != '0') {
          a.push(id);
          b.push(x);
        }
      });
      
      var data = {
        'id[]' : a,
        'act[]' : b
      };
      
      $.post(url.update_action, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          nav_list.show_list();
        }
        
        else {
          stat.show_status(1, result.message);
        }
      });
    }
    
    function get_search_param() {
      var param = {
        from_date : $('#id_from_date').val(),
        to_date : $('#id_to_date').val(),
        employee : encodeURIComponent($('#id_employee').val()),
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
          a.push('P');
          
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
      $('.date_input').datepicker(utils.date_opt());
      $('#id_find').click(nav_list.show_list);
      $('.chkall').click(check_all_status);
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_save,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.save_func = func_save;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }
    
    function load() {
      menu.get('/user/leave/', init);
    }
    
    return {
      load : load
    };
}());