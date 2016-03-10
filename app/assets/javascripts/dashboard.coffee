$(document).on 'page:change', ->
  $('.document').on 'click', (e) ->
    unless $(e.target).is '.actions a, .actions i'
      $(this).find('.title a').get(0).click()