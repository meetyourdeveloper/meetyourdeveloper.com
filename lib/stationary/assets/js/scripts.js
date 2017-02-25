var stickyLinks = document.getElementsByClassName("sticky")

for (i = 0; i < stickyLinks.length; i++) {
  if (isStickyOnly(stickyLinks[i]) || isStickyAny(stickyLinks[i]))
    stickyLinks[i].classList.add("active")
}

function isStickyOnly(el) {
  return (("undefined" !== typeof el.dataset.stickyOnly) &&
    (window.location.pathname == el.dataset.stickyOnly))
}

function isStickyAny(el) {
  var found = false
  if ("undefined" !== typeof stickyLinks[i].dataset.stickyAny) {
    el.dataset.stickyAny.split(",").forEach(function(data) {
      if (window.location.pathname.includes(data.trim())) found = true
    })
  }
  return found
}

function filterArchive() {
  var query = document.getElementById("archiveSearch").value.toLowerCase()
  var results = document.getElementsByClassName("searchable")

  if (query.length > 0) {
    for (var i = 0; i < results.length; i++) {
      if (results[i].dataset.match.toLowerCase().includes(query)) {
        show(results[i])
      } else { hide(results[i]) }
    }
  } else {
    for (var i = 0; i < results.length; i++) { show(results[i]) }
  }
}

function hide(el) { el.style.display = "none" }
function show(el) { el.style.display = "block" }
