var leavesummary = ( function() {
  var url = {
    list : '/leavesummary/list/'
  };
  
  function sort_list() {
      var s = sort.set_sort_css($(this));
      nav_list.set_sort(s);
    }

    function init_list() {
      $('.sortheader').click(sort_list);
    }
  
  function init() {
    $('#id_find').click(nav_list.show_list);
    $('#id_display,#id_selection').change(nav_list.show_list);
    $('#id_query').keypress(nav_list.query_keypress);
    $('#id_query').keyup(nav_list.query_keyup);
    $('#id_query').tooltip({track: true});
    utils.init_alert_dialog('#dialog-message');
    utils.bind_hover($('#id_save,#id_find'));
    nav_list.config.list_url = url.list;
    nav_list.config.list_func = init_list;
    nav_list.init();
  }
  
  function load () {
    return menu.get('/leavesummary/', init);
  }
  
  return {
    load : load
  };
}()); 