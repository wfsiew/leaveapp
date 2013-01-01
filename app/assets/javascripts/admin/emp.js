var emp = ( function() {
    var url = {
      add : '/admin/employee/new/',
      create : '/admin/employee/create/',
      edit : '/admin/employee/edit/',
      update : '/admin/employee/update/',
      del : '/admin/employee/delete/',
      list : '/admin/employee/list/'
    };
  
    var popup_dialog_opt = null;

    function init_ui_opt() {
      popup_dialog_opt = {
        autoOpen : false,
        width : 750,
        resizable : false,
        draggable : true,
        modal : false,
        stack : true,
        zIndex : 1000
      };
    }
  
    function show_form() {
      $('#dialog_add_body').load(url.add, function() {
        $('#tabs').tabs();
        $('.date_input').datepicker(utils.date_opt());
        $('.save_button.save').click(func_save);
        $('.save_button.cancel').click(func_cancel_add);
        $('#add-form').tooltip({track: true});
        utils.bind_hover($('.save_button'));
        $('#dialog-add').dialog('open');
      });
    }
  
    function save_success() {
      func_cancel_add();
      nav_list.show_list();
    }

    function update_success() {
      func_cancel_edit();
      nav_list.show_list();
    }
  
    function func_cancel_add() {
      $('#dialog-add').dialog('close');
      return false;
    }

    function func_cancel_edit() {
      $('#dialog-edit').dialog('close');
      return false;
    }
  
    function func_save() {
      var data = get_data('add');
      data = get_data_contact(data);
      data = get_data_ec_contact(data);
      data = get_data_job(data);
      data = get_data_spouse(data);
      $('#add-form input[type="text"]').next().remove();
      $('#add-form select').next().remove();
      $('#add-form').find('#lb_gender_f').next().remove();
      $.post(url.create, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          save_success();
        }
        
        else if (result.error == 1) {
          if (result.employee.error == 1) {
            for (var e in result.employee.errors) {
              var d = $('#error_' + e).get(0);
              if (!d) {
                var o = {
                  field : e,
                  msg : result.employee.errors[e]
                };
                var h = new EJS({
                  url : '/assets/tpl/label_error.html',
                  ext : '.html'
                }).render(o);
                if (e == 'gender')
                  $('#add-form').find('#form-employee').find('#lb_gender_f').after(h);
                
                else if (e == 'marital_status')
                  $('#add-form').find('#form-employee').find('#id_marital_status').after(h);
                
                else
                  $('#add-form').find('#form-employee').find("input[name='" + e + "']").after(h);
              }
            }
          }
          
          if (result.employee_contact.error == 1) {
            for (var e in result.employee_contact.errors) {
              var d = $('#error_' + e).get(0);
              if (!d) {
                var o = {
                  field : e,
                  msg : result.employee_contact.errors[e]
                };
                var h = new EJS({
                  url : '/assets/tpl/label_error.html',
                  ext : '.html'
                }).render(o);
                $('#add-form').find('#form-employee-contact').find("input[name='" + e + "']").after(h);
              }
            }
          }
          
          if (result.employee_ec_contact.error == 1) {
            for (var e in result.employee_ec_contact.errors) {
              var d = $('#error_' + e).get(0);
              if (!d) {
                var o = {
                  field : e,
                  msg : result.employee_ec_contact.errors[e]
                };
                var h = new EJS({
                  url : '/assets/tpl/label_error.html',
                  ext : '.html'
                }).render(o);
                $('#add-form').find('#form-employee-ec-contact').find("input[name='" + e + "']").after(h);
              }
            }
          }
          
          if (result.employee_job.error == 1) {
            for (var e in result.employee_job.errors) {
              var d = $('#error_' + e).get(0);
              if (!d) {
                var o = {
                  field : e,
                  msg : result.employee_job.errors[e]
                };
                var h = new EJS({
                  url : '/assets/tpl/label_error.html',
                  ext : '.html'
                }).render(o);
                if (e == 'designation_id' || e == 'department_id' || e == 'employment_status_id' || e == 'job_category_id')
                  $('#add-form').find('#form-employee-job').find('#id_' + e).after(h);
                  
                else
                  $('#add-form').find('#form-employee-job').find("input[name='" + e + "']").after(h);
              }
            }
          }
          
          if (result.employee_spouse.error == 1) {
            for (var e in result.employee_spouse.errors) {
              var d = $('#error_' + e).get(0);
              if (!d) {
                var o = {
                  field : e,
                  msg : result.employee_spouse.errors[e]
                };
                var h = new EJS({
                  url : '/assets/tpl/label_error.html',
                  ext : '.html'
                }).render(o);
                var id = (e == 'dob' ? 'spouse_dob' : e);
                alert(e);
                alert(id)
                $('#add-form').find('#form-employee-spouse').find('#id_' + id).after(h);
              }
            }
          }
          
          utils.show_dialog(1, 'There are validation errors in the form. Please complete all the required fields.');
        }
        
        else
          utils.show_dialog(2, result);
      });

      return false;
    }
  
    function func_edit(id) {
      if (!id)
        return false;

      id = utils.get_itemid(id);
      $('#dialog_edit_body').load(url.edit + id, function() {
        $('#tabs').tabs();
        $('.date_input').datepicker({
          dateFormat : utils.date_format,
          changeMonth : true,
          changeYear : true
        });
        $('.save_button.save').click(function() {
          return func_update(id);
        });
        $('.save_button.cancel').click(func_cancel_edit);
        $('#edit-form').tooltip({track: true});
        utils.bind_hover($('.save_button'));
        $('#dialog-edit').dialog('open');
      });
      return false;
    }
  
    function func_update(id) {
      
      return false;
    }
  
    function func_delete() {
      var a = $('.chk:checked');
      if (a.length < 1) {
        utils.show_dialog(2, 'Please select record(s).');
        return;
      }

      var l = [];
      var trlist = [];
      a.each(function(idx, elm) {
        var id = $(this).parent().parent().attr('id');
        trlist.push('#' + id);
        id = utils.get_itemid(id);
        l.push(id);
      });

      var val = $('#id_pg').val();
      var arr = val.split(',');
      var currpg = parseInt(arr[3], 10);
      --currpg;
      var pgsize = $('#id_display').val();
      var data = get_search_param();
      data['id[]'] = l;
      data['pgnum'] = currpg;
      data['pgsize'] = pgsize;

      $.post(url.del, data, function(result) {
        if (result.success == 1) {
          stat.show_status(0, result.message);
          nav_list.set_item_msg(result.itemscount);
          var tr = $(trlist.join(','));
          tr.remove();
          delete tr;
          if ($('.list_table tbody tr')[0] == null) {
            $('.list_table').remove();
            utils.set_disabled('#id_delete', 1, null);
          }
        }
      });
    }
  
    function select_all() {
      var a = $(this).attr('checked');
      if (a == 'checked')
        $('.chk').attr('checked', 'checked');
      
      else
        $('.chk').removeAttr('checked');
    }
  
    function get_data(t) {
      var form = (t == 'add' ? $('#add-form') : $('#edit-form'));

      var data = {
        staff_id : form.find('#id_staff_id').val(),
        first_name : form.find('#id_first_name').val(),
        middle_name : form.find('#id_middle_name').val(),
        last_name : form.find('#id_last_name').val(),
        new_ic : form.find('#id_new_ic').val(),
        old_ic : form.find('#id_old_ic').val(),
        passport_no : form.find('#id_passport_no').val(),
        gender : form.find("input:radio[name='gender']:checked").val(),
        marital_status : form.find('#id_marital_status').val(),
        nationality : form.find('#id_nationality').val(),
        dob : form.find('#id_dob').val(),
        place_of_birth : form.find('#id_place_of_birth').val(),
        race : form.find('#id_race').val(),
        religion : form.find('#id_religion').val(),
        is_bumi : form.find('#id_is_bumi').prop('checked'),
        user_id : form.find('#id_user_id').val(),
        supervisor_id : form.find('#id_supervisor_id').val()
      };

      return data;
    }
    
    function get_data_contact(o) {
      var form = $('#form-employee-contact');
      
      var data = {
        address_1 : form.find('#id_address_1').val(),
        address_2 : form.find('#id_address_2').val(),
        address_3 : form.find('#id_address_3').val(),
        city : form.find('#id_city').val(),
        state : form.find('#id_state').val(),
        postcode : form.find('#id_postcode').val(),
        country : form.find('#id_country').val(),
        home_phone : form.find('#id_home_phone').val(),
        mobile_phone : form.find('#id_mobile_phone').val(),
        work_email : form.find('#id_work_email').val(),
        other_email : form.find('#id_other_email').val()
      };
      
      o['employee_contact'] = data;
      
      return o;
    }
    
    function get_data_ec_contact(o) {
      var form = $('#form-employee-ec-contact');
      
      var data = {
        name : form.find('#id_name').val(),
        relationship : form.find('#id_relationship').val(),
        home_phone : form.find('#id_home_phone').val(),
        mobile_phone : form.find('#id_mobile_phone').val(),
        work_phone : form.find('#id_work_phone').val()
      };
      
      o['employee_ec_contact'] = data;
      
      return o;
    }
    
    function get_data_job(o) {
      var form = $('#form-employee-job');
      
      var data = {
        designation_id : form.find('#id_designation_id').val(),
        department_id : form.find('#id_department_id').val(),
        employment_status_id : form.find('#id_employment_status_id').val(),
        job_category_id : form.find('#id_job_category_id').val(),
        join_date : form.find('#id_join_date').val(),
        confirm_date : form.find('#id_confirm_date').val()
      };
      
      o['employee_job'] = data;
      
      return o;
    }
    
    function get_data_spouse(o) {
      var form = $('#form-employee-spouse');
      
      var data = {
        name : form.find('#id_name').val(),
        dob : form.find('#id_spouse_dob').val(),
        ic : form.find('#id_ic').val(),
        passport_no : form.find('#id_passport_no').val(),
        occupation : form.find('#id_occupation').val()
      };
      
      o['employee_spouse'] = data;
      
      return o;
    }
    
    function get_search_param() {
      var param = {
        employee : encodeURIComponent($('#id_employee').val()),
        staff_id : encodeURIComponent($('#id_staff_id').val()),
        employment_status : $('#id_employment_status').val(),
        supervisor : encodeURIComponent($('#id_supervisor').val()),
        designation : $('#id_designation').val(),
        dept : $('#id_dept').val()
      };
      
      return param;
    }
  
    function sort_list() {
      var s = sort.set_sort_css($(this));
      nav_list.set_sort(s);
    }

    function init_list() {
      $('.hdchk').click(select_all);
      utils.bind_hoverlist($('.list_table tbody tr'));
      $('.list_table tbody').selectable({
        selected : function(evt, ui) {
          var id = ui.selected.id;
          func_edit(id);
        }
      });
      $('.sortheader').click(sort_list);
    }

    function init() {
      init_ui_opt();
      $('#id_add').click(show_form);
      $('#id_find').click(nav_list.show_list);
      $('#id_display').change(nav_list.show_list);
      $('#id_employee,#id_staff_id,#id_supervisor').tooltip({track : true});
      $('#dialog-add').dialog(popup_dialog_opt);
      $('#dialog-edit').dialog(popup_dialog_opt);
      utils.init_alert_dialog('#dialog-message');
      utils.bind_hover($('#id_add,#id_delete,#id_find'));
      nav_list.config.list_url = url.list;
      nav_list.config.list_func = init_list;
      nav_list.config.del_func = func_delete;
      nav_list.config.search_param_func = get_search_param;
      nav_list.init();
    }

    function load() {
      return menu.get('/admin/employee/', init);
    }

    return {
      load : load
    };
}());