var info = ( function() {
  var save_url = '/user/info/update/';

  function func_save() {
    var data = get_data();
    $('#save-form input[type="text"]').next().remove();
    $('#save-form select').next().remove();
    $('#save-form').find('#lb_gender_f').next().remove();
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
              url : '/assets/tpl/label_error.html',
              ext : '.html'
            }).render(o);
            if (e == 'gender')
              $('#save-form #lb_gender_f').after(h);
                
            else if (e == 'marital_status')
              $('#save-form #id_marital_status').after(h);
                
            else
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
      first_name : $('#id_first_name').val(),
      middle_name : $('#id_middle_name').val(),
      last_name : $('#id_last_name').val(),
      new_ic : $('#id_new_ic').val(),
      old_ic : $('#id_old_ic').val(),
      passport_no : $('#id_passport_no').val(),
      gender : $("input:radio[name='gender']:checked").val(),
      marital_status : $('#id_marital_status').val(),
      nationality : $('#id_nationality').val(),
      dob : $('#id_dob').val(),
      place_of_birth : $('#id_place_of_birth').val(),
      race : $('#id_race').val(),
      religion : $('#id_religion').val(),
      is_bumi : $('#id_is_bumi').prop('checked')
    };

    return { employee : data } ;
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