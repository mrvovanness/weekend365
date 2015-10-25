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
  $('.popup-holder .open').click (e) ->
    e.preventDefault()
    popupHolder = $(this).parents('.popup-holder')
    popupHolder.addClass('popup-active')
    popupHolder.find('.popup').fadeIn(300)

  $('.popup .close').click (e) ->
    e.preventDefault()
    $(this).parent().fadeOut(100)
    $(this).parents('.popup-holder').removeClass('popup-active')

  # Change appearence of topic when toggling show/hide
  $('.btn-toggle-topic').click (e) ->
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
