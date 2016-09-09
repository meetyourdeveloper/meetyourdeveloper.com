var spotlight = function() {
  var path = window.location.pathname.split('/')[1];
  if (path === "") { path = ""; } // TODO: Add for blog, etc.
  var field = document.getElementById('spotlight');
  field.value = path;
};
