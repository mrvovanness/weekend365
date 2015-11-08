jQuery ->

  # Count filled textareas in particular element
  filledTextAreas = (elem) ->
    result = elem.find('.user-answer').filter ->
      return this.value.length > 0
    result.length

  # Count checked radiobuttons in particular element
  checkedRadioButtons = (elem) ->
    elem.find('input:checked').length

  # Calculate unanswered questions in particular element
  calcUnansweredQuestions = (elem) ->
    any_number = new RegExp /[0-9]+/
    numberOfQuestions = elem.find('span.question').length
    unansweredInfo = elem.find('.info').text()
    oldValue = unansweredInfo.match(any_number)[0]
    newValue = numberOfQuestions - checkedRadioButtons(elem) - filledTextAreas(elem)
    newText = unansweredInfo.replace(oldValue, newValue)
    elem.find('.info').text(newText)

  # Is survey filled?
  surveyFilled = ->
    sum = filledTextAreas($('fieldset')) + checkedRadioButtons($('fieldset'))
    $('span.question').length == sum

  # Check survey filling
  checkSurveyFilling = ->
    if surveyFilled()
      $('#submit-survey').prop('disabled', false)
      $('#submit-survey').val($('#submit-survey').data('submit'))
    else
      $('#submit-survey').prop('disabled', true)
      $('#submit-survey').val($('#submit-survey').data('not-submit'))

  $('.agree .level').click ->

    # Apply style on answer option click
    $(this).parents('.agree').find('li').removeClass('active')
    $(this).parent().addClass('active')
    $(this).next().prop('checked', 'true')

    topicHeader = $(this).parents('.topic-header')
    calcUnansweredQuestions(topicHeader)
    checkSurveyFilling()

  $('.user-answer').keyup ->
    topicHeader = $(this).parents('.topic-header')
    calcUnansweredQuestions(topicHeader)
    checkSurveyFilling()

  # Synchonize hidden field for answer comment with textarea for comment
  $('.comment-input').keyup ->
    commentText = $(this).val()
    $(this).parents('.question-block').find('.hidden-comment-field').val(commentText)
