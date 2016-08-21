var spotlight = function() {
  var path = window.location.pathname.split('/')[1];
  if (path === "") { path = "johndoe"; }
  var field = document.getElementById('spotlight');
  field.value = path;
};
