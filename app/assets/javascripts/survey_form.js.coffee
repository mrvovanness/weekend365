jQuery ->
  $('#survey_start_on, #survey_finish_on').datepicker
    dateFormat: 'dd-mm-yy'
  $('#survey_start_at').timepicker()
  $('#survey_employee_ids').select2()
