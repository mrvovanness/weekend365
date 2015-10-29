jQuery ->

  # Dinamically add/remove email recepients and respond with number of recipients in label text
  number = new RegExp /\([0-9]\):/
  labelText = $('#send_to-label').text().replace(number, '')

  $('.edit_company_survey').on 'ajax:complete', (e, data, status, xhr) ->
    message = JSON.parse(data.responseText)
    $('.control-label', this).html(
      labelText + '(' + message.employees_count + '):'
    )

  $('.survey_start_on').datetimepicker
    format: 'Y-m-d'
    timepicker: false
    minDate: 0
    lang: $('html').attr('lang')
    scrollInput: false

  $('.survey_time').datetimepicker
    format: 'H:i'
    datepicker: false
    lang: $('html').attr('lang')

  $('.survey_finish_on').datetimepicker
    format: 'Y-m-d'
    timepicker: false
    minDate: '+1970/01/03'
    lang: $('html').attr('lang')
    scrollInput: false

  # just helper for ajax response
  joinValues = (obj) ->
    name = obj.name + ' - '
    department = obj.department + ' - '
    position = obj.position
    return name + department + position

  # Search via ajax in 'send to' form field
  $('#employee_ids').select2
    tags: true
    closeOnSelect: false
    placeholder: $('#employee_ids').attr('placeholder')
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

  # Add all employees
  $('#add_all_employees').click (e) ->
    e.preventDefault()
    employees = $('#employee_ids option').map ->
      $( this ).val()
    .get()
    $('#employee_ids').val(employees).trigger('change')

  # Modal window
  $('#dialog').dialog
    autoOpen: false
    modal: true
    draggable: false
    resizable: false
    width: 500

  # Calculate number of repeats
  calculateRepeats = ->
    startOn = new Date $('#survey_start_on').val()
    finishOn = new Date $('.survey_finish_on').val()
    repeatEvery = $('.survey_repeat_every').val()
    repeatMode = $('.survey_repeat_mode').val()
    daysInterval = if repeatMode == 'w' then repeatEvery * 7 else repeatEvery

    diff = (finishOn - startOn)/(1000*60*60*24)/daysInterval
    result = if diff < 2 then 2 else diff
    numberOfRepeats = Math.floor(result)
    $('.survey_number_of_repeats').val(numberOfRepeats)
  
  $(document).ready calculateRepeats
  $('.schedule-setter').on 'change', calculateRepeats
