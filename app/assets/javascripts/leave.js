var leave = ( function() {
  var url = {
    list : '/leave/list/'
  };
  
  function func_save() {
    
  }
  
  function init() {
    
    utils.init_alert_dialog('#dialog-message');
    utils.bind_hover($('#id_save,#id_find'));
    nav_list.config.list_url = url.list;
    nav_list.config.save_func = func_save;
    nav_list.init();
  }
  
  function load() {
    return menu.get('/leave/', init);
  }
  
  return {
    load : load
  };
}());