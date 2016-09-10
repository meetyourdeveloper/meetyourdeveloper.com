var spotlight = function() {
  var path = window.location.pathname.split('/')[1];
  if (path === "") { path = ""; } // TODO: Add for blog, etc.
  // if (path === "thanks") {
  //   var form = document.getElementById('spotlight-form');
  //   form.style.display = "none"
  // }
  var field = document.getElementById('spotlight');
  field.value = path;
};
