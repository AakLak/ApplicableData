//Add alert-success to class for styling
//AdminLTE theme & Devise differing class names
function addAlert() {
  alerts = $('.alert-notice')
  for (var i = 0; i < alerts.length; i++) {
   alerts[i].className += ' alert-success';
 }
}

function reloadPage() {
  location.reload();
}