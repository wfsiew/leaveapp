var spouse = ( function() {
  var save_url = '/user/spouse/update/';
  
  function func_save() {
    var data = get_data();
    $('#save-form input[type="text"]').next().remove();
    $.post(save_url, data, function(result) {
      if (result.success == 1)
        stat.show_status(0, result.message);
        
      else if (result.error == 1) {
        for (var e in result.errors) {
          var d = $('#save-form #error_' + e).get(0);
          if (!d) {
            var o = {
              field : e,
              msg : result.errors[e]
            };
            var h = new EJS({
              url : '/assets/tpl/label_error_inline.html',
              ext : '.html'
            }).render(o);
            $("#save-form input[name='" + e + "']").after(h);
          }
        }
      }
      
      else
        utils.show_dialog(2, result);
    });
    
    return false;
  }
  
  function get_data() {
    var data = {
      name : $('#id_name').val(),
      dob : $('#id_spouse_dob').val(),
      ic : $('#id_ic').val(),
      passport_no : $('#id_passport_no').val(),
      occupation : $('#id_occupation').val()
    };
    
    return { employee_spouse : data };
  }
  
  function init() {
    $('.date_input').datepicker(utils.date_opt());
    $('.save_button.save').click(func_save);
    $('#save-form').tooltip({track: true});
    utils.bind_hover($('.save_button'));
    utils.init_alert_dialog('#dialog-message');
  }
  
  function load() {
    return menu.get('/user/spouse/', init);
  }
  
  return {
    load : load
  };
}());