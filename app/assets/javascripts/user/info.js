var info = ( function() {
  
  function init() {
    
  }
  
  function load() {
    return menu.get('/user/info/', init);
  }
  
  return {
    load : load
  };
}());