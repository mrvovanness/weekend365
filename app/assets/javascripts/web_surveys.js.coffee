jQuery ->
  $('.web-survey-save').click ->
    $('#survey-form').submit()

  # Pop up comment to answer (show/hide)
  $('.popup-holder .open').click (e) ->
    popupHolder = $(this).parents('.popup-holder')
    popupHolder.addClass('popup-active')
    popupHolder.find('.popup').fadeIn(300)

  $('.popup .close').click ->
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
