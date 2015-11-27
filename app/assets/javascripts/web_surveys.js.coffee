jQuery ->
  $('.web-survey-save').click ->
    $('#survey-form').submit()

  # Disable some inputs if 'once' chosen
  deactivateInputs = ->
    $('#repeat-block').fadeOut(500)
    $('#repeat-block').find(':input').prop 'disabled', true

  activateInputs = ->
      $('#repeat-block').fadeIn(500)
      $('#repeat-block').find(':input').prop 'disabled', false

  setRepeatingBlock = ->
    if $('#company_survey_repeat_false').prop 'checked'
      deactivateInputs()
    else
      activateInputs()

  $('#company_survey_repeat_false').click ->
    deactivateInputs()

  $('#company_survey_repeat_true').click ->
    activateInputs()

  setRepeatingBlock()

  # Pop up comment to answer (show/hide)
  $('.box').on 'click', '.popup-holder .open', (e) ->
    e.preventDefault()
    popupHolder = $(this).parents('.popup-holder')
    popupHolder.addClass('popup-active')
    popupHolder.find('.popup').fadeIn(300)

  $('.box').on 'click', '.popup .close', (e) ->
    e.preventDefault()
    $(this).parent().fadeOut(100)
    $(this).parents('.popup-holder').removeClass('popup-active')

  $('.box').on 'click', '.popup-active .btn-comments.open', (e) ->
    e.preventDefault()
    $(this).next('.popup').fadeOut(100)
    $(this).parents('.popup-holder').removeClass('popup-active')

  # Change appearence of topic when toggling show/hide
  $('.box').on 'click', '.btn-toggle-topic', (e) ->
    e.preventDefault()
    topicBlock = $(this).parents('.topic-block')
    topicBar = $(this).prev()

    if topicBar.hasClass('deleted')
      topicBlock.find('.hidden-question-input').prop('disabled', false)
      topicBar.removeClass('deleted')
      topicBar.removeAttr('style')
      $(this).removeAttr('style')
      $(this).children().removeAttr('style')
    else
      topicBlock.find('.hidden-question-input').prop('disabled', true)
      topicBar.addClass('deleted')
      topicBar.css({'background-color': '#dcdbdb'})
      $(this).css({'background-color': '#ef9825'})
      $('em', this).css({'display': 'none'})
      $('span', this).css({'display': 'block'})

  $('.user-question-start').click (e) ->
    e.preventDefault()
    $('#new-question-form').dialog('open')

  $('.user-question-finish').click (e) ->
    e.preventDefault()
    $('#new_offered_question').submit()
    $('#new-question-form').find('.cleanable :input').val('')

  # Validation of new question form
  $('#offered_question_title, #offered_question_topic').keyup (e) ->
    if $('#offered_question_topic').val() != '' && $('#offered_question_title').val() != ''
      $('.user-question-finish').prop('disabled', false)
      $('.user-question-finish').css('border-color', 'green')
    else
      $('.user-question-finish').prop('disabled', true)
      $('.user-question-finish').css('border-color', 'red')

  $('#new-question-form').dialog
    autoOpen: false

  # Finder for autocomplete
  findTopics = (searchTerm) ->
    topicsArray = $('.opener span').map ->
      return $(this).text()
    search = $.ui.autocomplete.escapeRegex(searchTerm)
    console.log search
    $.grep topicsArray, (item, i) ->
      return item.match(new RegExp search)


  $('#offered_question_topic').autocomplete
    minLength: 0
    source: (request, response) ->
      response(findTopics(request.term))
