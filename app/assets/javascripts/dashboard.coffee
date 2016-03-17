onPage 'users show', ->
  # Whole .document div as link
  $('.document').on 'click', (e) ->
    unless $(e.target).is '.actions a, .actions i'
      $(this).find('.title a').get(0).click()
      
  # Remove deleted .document from page after Ajax request
  $('.document .actions a[data-method="delete"]').on 'ajax:success', ->
    $(this).parents('.document').remove()