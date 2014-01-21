function syncDateInput(dateInput, dateTimeInput) {
  dateInput.val(dateTimeInput.val().split(' ')[0]);
  dateTimeInput.val(dateTimeInput.val().split(' ').pop());
}

function syncDateTimeInput(dateInputSelector, $dateTimeInput){
  $dateTimeInput.val($(dateInputSelector).val() + ' ' + $dateTimeInput.val().split(' ').pop());
}

$(function() {
  $('#issue_starting_hours').datetimepicker({
    format: 'Y-m-d H:i',
    validateOnBlur: false,
    onChangeDateTime: function(dp, $input){
      syncDateInput($('#issue_start_date'), $input);
    },
    onShow: function(dp, $input){
      syncDateTimeInput('#issue_start_date', $input)
    }
  });
  $('#issue_finishing_hours').datetimepicker({
    format: 'Y-m-d H:i',
    validateOnBlur: false,
    onChangeDateTime: function(dp, $input){
      syncDateInput($('#issue_due_date'), $input);
    },
    onShow: function(dp, $input){
      syncDateTimeInput('#issue_due_date', $input)
    }
  });
});
