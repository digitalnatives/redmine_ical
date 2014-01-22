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
  $dateTimeInput.val($(dateInputSelector).val() + ' ' + $dateTimeInput.val().split(' ').pop());

  var datetime_data = datetimepicker.data().xdsoft_datetime;
  datetime_data.setCurrentTime(datetime_data.strtodatetime($dateTimeInput.val()))
}

function configureDateTimePicker(dateTimeInputSelector, dateInputSelector) {
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
  configureDateTimePicker('#issue_starting_hours', '#issue_start_date');
  configureDateTimePicker('#issue_finishing_hours', '#issue_due_date');
});
