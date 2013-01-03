var leavesummary = ( function() {
    var url = {
      list : '/user/leave/summary/list/'
    };
    
    function get_search_param() {
      var param = {
        year : $('#id_year').val(),
        leave_type : $('#id_leave_type').val()
      };
      
      return param;
    }

    function init() {
      $('#id_find').click(nav_list.show_list);
      $('#id_display').change(nav_list.show_list);
      $('#id_year').tooltip({track : true});
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }

    function load() {
      return menu.get('/user/leave/summary/', init);
    }

    return {
      load : load
    };
}());