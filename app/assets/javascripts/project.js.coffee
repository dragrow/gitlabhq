class @Project
  constructor: ->
    # Git protocol switcher
    $('.js-protocol-switch').click ->
      return if $(@).hasClass('active')

      # Toggle 'active' for both buttons
      $('.js-protocol-switch').toggleClass('active')

      url = $(@).data('clone')

      # Update the input field
      $('#project_clone').val(url)

      # Update the command line instructions
      $('.clone').text(url)

    # Ref switcher
    $('.project-refs-select').on 'change', ->
      $(@).parents('form').submit()

    $('.hide-no-ssh-message').on 'click', (e) ->
      path = '/'
      $.cookie('hide_no_ssh_message', 'false', { path: path })
      $(@).parents('.no-ssh-key-message').remove()
      e.preventDefault()

    $('.hide-no-password-message').on 'click', (e) ->
      path = '/'
      $.cookie('hide_no_password_message', 'false', { path: path })
      $(@).parents('.no-password-message').remove()
      e.preventDefault()

    $('.update-notification').on 'click', (e) ->
      e.preventDefault()
      notification_level = $(@).data 'notification-level'
      $('#notification_level').val(notification_level)
      $('#notification-form').submit()
      label = null
      switch notification_level
        when 0 then label = ' Disabled '
        when 1 then label = ' Participating '
        when 2 then label = ' Watching '
        when 3 then label = ' Global '
        when 4 then label = ' On Mention '
      $('#notifications-button').empty().append("<i class='fa fa-bell'></i>" + label + "<i class='fa fa-angle-down'></i>")
      $(@).parents('ul').find('li.active').removeClass 'active'
      $(@).parent().addClass 'active'
