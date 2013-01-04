var myleave = ( function() {

    function init() {

    }
    
    function load() {
      menu.get('/user/leave/own/', init);
    }
    
    return {
      load : load
    };
}()); 