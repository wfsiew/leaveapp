var info = ( function() {
  var save_url = "/user/info/save/";

  function func_save() {
    var data = get_data();

    return false;
  }

  function get_data() {
    var data = {
    };

    return data;
  }
  
  function init() {
    $('.date_input').datepicker(utils.date_opt());
    $('.save_button.save').click(func_save);
    $('#save-form').tooltip({track: true});
    utils.bind_hover($('.save_button'));
    utils.init_alert_dialog('#dialog-message');
  }
  
  function load() {
    return menu.get('/user/info/', init);
  }
  
  return {
    load : load
  };
}());