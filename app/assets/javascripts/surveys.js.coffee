jQuery ->
  $('#survey_start_at').datetimepicker
    format: 'Y-M-d H:i'

  $('#survey_finish_on').datetimepicker
    format: 'Y-M-d'

  $('#survey_employee_ids').select2()

  $('#reset-btn').click (e) ->
    e.preventDefault()
    $('#survey_employee_ids').select2 'data', []
