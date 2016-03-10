$(document).on 'page:change', ->
  if $('.error-messages-box').prev().length
    sectionTop = $('.error-messages-box').prev().offset().top
    $(window).scrollTop(sectionTop)
    
  $('.field_with_errors>input').first().focus()