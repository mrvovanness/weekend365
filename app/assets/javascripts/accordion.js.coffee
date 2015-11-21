jQuery ->
  $('.box').on 'click', '.opener', (e) ->
    e.preventDefault()
    $(this).parents('.topic-block').find('.slide').toggle('fast')
