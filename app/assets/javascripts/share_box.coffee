onPage 'users show, notes show, checklists show', ->
  # Display sweet alert with share url
  $('.actions a[data-share-url]').on 'click', ->
    swal
      title: 'Share using this link'
      type: 'input'
      inputValue: $(this).data('share-url')
      allowEscapeKey: false,
      ->
        # Prevent from displaying copy button in other alerts
        $('.sweet-alert .copy-link').remove()
      
    # Add 'copy to clipboard' button
    if $('.sweet-alert .copy-link').length == 0
      $('.sweet-alert .sa-confirm-button-container').after """
      <button class="copy-link" data-clipboard-target=".sweet-alert input"
        title="Copy to clipboard">
        <i class="fa fa-clipboard"></i>
      </button>
      """
    
    clipboard = new Clipboard('.copy-link')