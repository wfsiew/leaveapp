var asgnleave = ( function() {
    var url = {
      create : '/admin/asgnleave/create/'
    };

    function func_save() {
      var data = get_data();
      $.post(url.create, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          load();
        }
        
        else if (result.error == 1) {
          for (var e in result.errors) {
            var d = $('#error_' + e).get(0);
            if (!d) {
              var o = {
                field : e,
                msg : result.errors[e][0]
              };
              var h = new EJS({
                url : '/assets/tpl/label_error.html',
                ext : '.html'
              }).render(o);
              if (e == 'leave_type_id')
                $("#save-form select[name='" + e + "']").after(h);
              
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
      var form = $('#save-form');

      var data = {
        staff_id : form.find('#id_staff_id').val(),
        leave_type_id : form.find('#id_leave_type').val(),
        day : form.find('#id_day').val(),
        from_date : form.find('#id_from_date').val(),
        to_date : form.find('#id_to_date').val(),
        reason : form.find('#id_reason').val(),
        day_type : form.find("input[name='day_type']:checked").val()
      };

      return data;
    }

    function init() {
      utils.init_alert_dialog('#dialog-message');
      $('#save-form').tooltip({track : true});
      $('.save_button.save').click(func_save);
      utils.bind_hover($('.save_button'));
      $('#id_from_date,#id_to_date').datepicker({
        dateFormat : utils.date_format,
        changeMonth : true,
        changeYear : true
      });
    }

    function load() {
      return menu.get('/admin/asgnleave/', init);
    }

    return {
      load : load
    }
}()); 