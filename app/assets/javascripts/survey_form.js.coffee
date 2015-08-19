jQuery ->
  $('#survey_start_at').datetimepicker
    format: 'YYYY-MM-DD HH:mm'
  $('#survey_finish_on').datetimepicker
    format: 'YYYY-MM-DD'
  $('#survey_employee_ids').select2()
