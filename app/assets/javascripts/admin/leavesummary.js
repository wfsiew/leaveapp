var leavesummary = ( function() {
    var url = {
      list : '/admin/leave/summary/list/',
      create : '/admin/leave/summary/create/'
    };

    function func_save() {
      var empids = [];
      var leavetypeids = [];
      var leaveent = [];

      $("input[name='hdnEmpId[]']").each(function(idx, elm) {
        empids.push($(this).val());
      });

      $("input[name='hdnLeaveTypeId[]']").each(function(idx, elm) {
        leavetypeids.push($(this).val());
      });

      $("input[name='txtLeaveEntitled[]']").each(function(idx, elm) {
        leaveent.push($(this).val());
      });

      var data = {
        'empids[]' : empids,
        'leavetypeids[]' : leavetypeids,
        'leaveent[]' : leaveent,
        year : $('#id_year').val()
      };

      $.post(url.create, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
        }
        
        else {
          stat.show_status(1, result.message);
        }
      });

      return false;
    }
    
    function get_search_param() {
      var param = {
        employee : $('#id_employee').val(),
        leave_type : $('#id_leave_type').val(),
        designation : $('#id_designation').val(),
        dept : $('#id_dept').val(),
        year : $('#id_year').val()
      };
      
      return param;
    }

    function init() {
      $('#id_find').click(nav_list.show_list);
      $('#id_display').change(nav_list.show_list);
      $('#id_employee,#id_year').tooltip({track : true});
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_save,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.save_func = func_save;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }

    function load() {
      return menu.get('/admin/leave/summary/', init);
    }

    return {
      load : load
    };
}());