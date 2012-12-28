var leave = ( function() {
    var url = {
      edit : '/admin/leave/edit/',
      update : '/admin/leave/update/',
      update_action : '/admin/leave/action/update/',
      list : '/admin/leave/list/'
    };
    
    var popup_dialog_opt = null;
    
    function init_ui_opt() {
      popup_dialog_opt = {
        autoOpen : false,
        width : 350,
        resizable : false,
        draggable : true,
        modal : false,
        stack : true,
        zIndex : 1000
      };
    }
    
    function update_success() {
      func_cancel_edit();
      nav_list.show_list();
    }
    
    function func_cancel_edit() {
      $('#dialog-edit').dialog('close');
      return false;
    }

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
    
    function func_edit() {
      var id = $(this).parent().parent().attr('id');
      id = utils.get_itemid(id);
      $('#dialog_edit_body').load(url.edit + id, function() {
        $('.save_button.save').click(function() {
          return func_update(id);
        });
        $('.save_button.cancel').click(func_cancel_edit);
        $('#edit-form').tooltip({track: true});
        utils.bind_hover($('.save_button'));
        $('#dialog-edit').dialog('open');
      });
      return false;
    }
    
    function func_update(id) {
      var data = get_data();
      $.post(url.update + id, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          update_success();
        }
        
        else if (result.success == 0)
          func_cancel_edit();
          
        else
          utils.show_dialog(2, result);
      });
      
      return false;
    }
    
    function get_data() {
      var form = $('#edit-form');

      var data = {
        reason : form.find('#id_reason').val()
      };

      return data;
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
    
    function init_list() {
      $('.editreason').click(func_edit);
    }

    function init() {
      init_ui_opt();
      $('#id_from_date,#id_to_date').datepicker({
        dateFormat : utils.date_format,
        changeMonth : true,
        changeYear : true
      });
      $('#id_find').click(nav_list.show_list);
      $('#id_employee').tooltip({track: true});
      $('.chkall').click(check_all_status);
      $('#dialog-edit').dialog(popup_dialog_opt);
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_save,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.list_func = init_list;
      nav_list.config.save_func = func_save;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }

    function load() {
      return menu.get('/admin/leave/', init);
    }

    return {
      load : load
    };
}());