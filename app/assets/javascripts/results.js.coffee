jQuery ->
  $('.agree .level').click ->

    # Apply style on answer option click and calculate unanswered questions
    $(this).parents('.agree').find('li').removeClass('active')
    $(this).parent().addClass('active')
    $(this).next().prop('checked', 'true')

    any_number = new RegExp /[0-9]+/
    topicHeader = $(this).parents('.topic-header')
    numberOfQuestions = topicHeader.find('span.question').length
    unansweredInfo = topicHeader.find('.info').text()
    oldValue = unansweredInfo.match(any_number)[0]
    newValue = numberOfQuestions - topicHeader.find('input:checked').length
    newText = unansweredInfo.replace(oldValue, newValue)
    topicHeader.find('.info').text(newText)

    if $('input:checked').length == $('span.question').length
      $('#submit-survey').prop('disabled', false)
      $('#submit-survey').val($('#submit-survey').data('submit'))

  $('.comment-input').focusout ->

    # Synchonize hidden field for answer comment with textarea for comment
    commentText = $(this).val()
    $(this).parents('.question-block').find('.hidden-comment-field').val(commentText)
