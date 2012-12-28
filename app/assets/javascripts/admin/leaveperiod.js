var leaveperiod = ( function() {
    var url = {
      todate : '/admin/leaveperiod/todate/',
      create : '/admin/leaveperiod/create/'
    };

    function get_to_date() {
      var s = $('#id_dayselect').val() + '-' + $('#id_monthselect').val();
      var data = {
        from_date : s
      };
      $.get(url.todate, data, function(result) {
        if (result.error == 1)
          utils.show_dialog(2, result.errors);
        
        else {
          $('#id_todate').text(result.to_date);
          $('#id_todateval').val(result.to_date_val);
        }
      });
      $('.save_button.save').click(func_save);
    }

    function func_save() {
      var data = get_data();
      $.post(url.create, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          load();
        }
        
        else if (result.error == 1) {
          alert('error');
        }
        
        else
          utils.show_dialog(2, result);
      });

      return false;
    }

    function get_data() {
      var data = {
        from_date : $('#id_dayselect').val() + '-' + $('#id_monthselect').val(),
        to_date : $('#id_todateval').val()
      };

      return data;
    }

    function init() {
      utils.init_alert_dialog('#dialog-message');
      $('#id_monthselect,#id_dayselect').change(get_to_date);
      $('.save_button.save').click(func_save);
      utils.bind_hover($('.save_button'));
    }

    function load() {
      return menu.get('/admin/leaveperiod/', init);
    }

    return {
      load : load
    };
}()); 