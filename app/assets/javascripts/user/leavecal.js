var leavecal = ( function() {
    var url = {
      data : '/user/leave/cal/data/'
    };

    function init() {
      $('#calendar').fullCalendar({
        theme : true,
        events : {
          url : url.data,
          className : 'ui-state-active'
        }
      });
      utils.init_alert_dialog('#dialog-message');
    }
    
    function load() {
      menu.get('/user/leave/cal/', init);
    }
    
    return {
      load : load
    };
}()); 