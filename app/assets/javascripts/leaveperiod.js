var leaveperiod = ( function() {
  function get_to_date() {
    var s = $('#id_dayselect').val() + '-' + $('#id_monthselect').val();
    var data = {
      from_date : s
    };
    $.get('/leaveperiod/todate/', data, function(result) {
      if (result.error == 1)
        utils.show_dialog(2, result.errors);
        
      else {
        $('#id_todate').text(result.to_date);
        $('#id_todateval').val(result.to_date_val);
      }
    });
  }
  
  function init() {
    utils.init_alert_dialog('#dialog-message');
    $('#id_monthselect,#id_dayselect').change(get_to_date);
  }
  
  function load() {
    return menu.get('/leaveperiod/', init);
  }
  
  return {
    load : load
  };
}());