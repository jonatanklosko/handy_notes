onPage 'linksets show', ->
  # Show modal
  $('.add-link').on 'click', ->
    $(this).find('.name a').get(0).click()
    $('.modal-overlay').show()
    
  # Show loading icon and hide form when Ajax request is sent
  $(document).on 'ajax:send', ->
    $('.modal-window .loading').show()
    $('.modal-window .form').hide()
    
  # Hide loading icon and show form when Ajax request is completed
  $(document).on 'ajax:complete', ->
    $('.modal-window .loading').hide()
    $('.modal-window .form').show()
    $('.modal-window input[type="text"]:first').focus()
    # Hide the modal when 'Cancel' is clicked
    $('.cancel').on 'click', (e) ->
      e.preventDefault()
      $('.modal-overlay').hide()
  
  # Make whole link div clickable
  $('.links').on 'click', '.link', (e) ->
    unless $(e.target).is '.name a'
      $(this).find('.name a').get(0).click()