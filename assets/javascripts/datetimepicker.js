function syncDateInputs(dateInput, dateTimeInput) {
  var dateTimeParts = dateTimeInput.val().split(' ');
  if (dateTimeParts.length > 1) {
    dateInput.val(dateTimeParts[0]);
    dateTimeInput.val(dateTimeParts.pop());
  }
}

function removeDateFromDateTimeInput(dateTimeInput) {
  dateTimeInput.val(dateTimeInput.val().split(' ').pop());
}

function syncDateTimeInput(dateInputSelector, $dateTimeInput, datetimepicker){
  $dateTimeInput.val($(dateInputSelector).val() + ' ' + $dateTimeInput.val().split(' ').pop().replace(/(..:..).*/, "$1:00"));

  var datetime_data = datetimepicker.data().xdsoft_datetime;
  datetime_data.setCurrentTime(datetime_data.strtodatetime($dateTimeInput.val()))
}

function configureDateTimePicker(dateTimeInputSelector, dateInputSelector) {
  var dateValue = $(dateInputSelector).val();
  if ((!dateValue || 0 === dateValue.length)) {
    var d = new Date();
    var year = d.getFullYear();
    var month = ("0" + (d.getMonth() + 1)).slice(-2);
    var day = ("0" + d.getDate()).slice(-2);
    $(dateInputSelector).val(year + "-" + month + "-" + day);
  }
  $(dateTimeInputSelector).datetimepicker({
    format: 'Y-m-d H:i:s',
    validateOnBlur: false,
    step: 30,
    onChangeDateTime: function(dp, $input){
      syncDateInputs($(dateInputSelector), $input);
    },
    onClose: function(dp, $input){
      removeDateFromDateTimeInput($input);
    },
    onShow: function(dp, $input){
      syncDateTimeInput(dateInputSelector, $input, this)
    }
  });
}

$(function() {
  // This is code is using the deprecated event DOMSubtreeModified.
  // Redmine does not give no other option as it changes the internal HTML
  // and does not fire up any event to notify a possible listener. For more
  // details see the Redmine source code file named update_form.js.erb
  var dueDateInitialValue = $('#issue_due_date').val();
  $('#all_attributes').bind("DOMSubtreeModified", function(){
    if ($('#issue_starting_hours').length) {
      configureDateTimePicker('#issue_starting_hours', '#issue_start_date');
    }
    if ($('#issue_finishing_hours').length) {
      configureDateTimePicker('#issue_finishing_hours', '#issue_due_date');
    }
    else {
      $('#issue_due_date').val(dueDateInitialValue);
    }
  });
});
