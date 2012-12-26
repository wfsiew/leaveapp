var leavesummary = ( function() {
    var url = {
      list : '/leavesummary/list/',
      create : '/leavesummary/create/'
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
        'leaveent[]' : leaveent
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

    function init() {
      $('#id_find').click(nav_list.show_list);
      $('#id_display,#id_selection').change(nav_list.show_list);
      $('#id_query').keypress(nav_list.query_keypress);
      $('#id_query').keyup(nav_list.query_keyup);
      $('#id_query').tooltip({track : true});
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_save,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.save_func = func_save;
      nav_list.init();
    }

    function load() {
      return menu.get('/leavesummary/', init);
    }

    return {
      load : load
    };
}());