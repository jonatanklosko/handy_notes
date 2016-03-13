onPage 'checklists new, checklists create, ' +
      'checklists edit, checklists update', ->
            
  items = $('.items')
  
  items.on 'input', 'input:last-child', ->
    if $(this).val() != ""
      newItemInput = $(this).clone()
      newItemInput.val ''
      itemId = +$(this).attr('name').match(/\d+/) + 1
      newItemInput.attr 'name', 'new_items[' + itemId + ']'
      newItemInput.attr 'id', 'new_items_' + itemId
      $('.items').append newItemInput
  
  items.on 'input', 'input:not(:last-child)', ->
    if $(this).val() == ""
      $(this).remove()
      items.find('input:last').focus()