var reportto = ( function() {

    function init() {
    }

    function load() {
      return menu.get('/user/reportto/', init);
    }

    return {
      load : load
    };
}()); 