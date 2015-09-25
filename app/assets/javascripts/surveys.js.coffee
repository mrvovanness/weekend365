jQuery ->

  # Dinamically add/remove email recepients and respond with number of recipients
  $('.edit_company_survey').on 'ajax:complete', (e, data, status, xhr) ->
    message = JSON.parse(data.responseText)
    $('.control-label', this).html('Send to ' + '(' + message.employees_count + '):')

  $('#company_survey_start_on').datetimepicker
    format: 'Y-m-d'
    timepicker: false
    minDate: 0

  $('#company_survey_time').datetimepicker
    format: 'H:i'
    datepicker: false

  $('#company_survey_finish_on').datetimepicker
    format: 'Y-m-d'
    timepicker: false
    minDate: '+1970/01/03'

  # just helper for ajax response
  joinValues = (obj) ->
    name = obj.name + ' - '
    department = obj.department + ' - '
    position = obj.position
    return name + department + position

  # Search via ajax in 'send to' form field
  $('#company_survey_employee_ids').select2
    tags: true
    closeOnSelect: false
    placeholder: 'Search by name, department, position ...'
    allowClear: true
    delay: 500
    ajax:
      url: '/employees'
      dataType: 'json'
      data: (params) ->
        q: { name_or_department_or_position_cont: params.term }
      processResults: (data) ->
        return {
          results: $.map data.employees, (obj) ->
            return { id: obj.id, text: joinValues(obj) } }

  # Modal window
  $('#dialog').dialog
    autoOpen: false
    modal: true
    draggable: false
    resizable: false
    width: 500

  $('#add-survey-btn, .btn-create').click (e) ->
    e.preventDefault()
    $('#dialog').dialog 'open'

  # Calculate number of repeats
  calculateRepeats = ->
    finishOn = new Date $('#company_survey_finish_on').val()
    startOn = new Date $('#company_survey_start_on').val()
    repeatEvery = $('#company_survey_repeat_every').val()
    repeatMode = $('#company_survey_repeat_mode').val()
    daysInterval = if repeatMode == 'w' then repeatEvery * 7 else repeatEvery

    diff = (finishOn - startOn)/(1000*60*60*24)/daysInterval
    result = if diff < 2 then 2 else diff
    numberOfRepeats = Math.floor(result)
    $('#company_survey_number_of_repeats').val(numberOfRepeats)
  
  $('.schedule-setter').on 'change', calculateRepeats
