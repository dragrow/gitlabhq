class @MergeRequestWidget
  # Initialize MergeRequestWidget behavior
  #
  #   check_enable           - Boolean, whether to check automerge status
  #   url_to_automerge_check - String, URL to use to check automerge status
  #   current_status         - String, current automerge status
  #   ci_enable              - Boolean, whether a CI service is enabled
  #   url_to_ci_check        - String, URL to use to check CI status
  #
  constructor: (@opts) ->
    modal = $('#modal_merge_info').modal(show: false)

  mergeInProgress: ->
    $.ajax
      type: 'GET'
      url: $('.merge-request').data('url')
      success: (data) =>
        if data.state == "merged"
          location.reload()
        else if data.merge_error
          $('.mr-widget-body').html("<h4>" + data.merge_error + "</h4>")
        else
          setTimeout(merge_request_widget.mergeInProgress, 2000)
      dataType: 'json'

  rebaseInProgress: ->
    $.ajax
      type: 'GET'
      url: $('.merge-request').data('url')
      success: (data) =>
        debugger
        if data["rebase_in_progress?"]
          setTimeout(merge_request_widget.rebaseInProgress, 2000)
        else
          location.reload()
      dataType: 'json'

  getMergeStatus: ->
    $.get @opts.url_to_automerge_check, (data) ->
      $('.mr-state-widget').replaceWith(data)

  getCiStatus: ->
    if @opts.ci_enable
      $.get @opts.url_to_ci_check, (data) =>
        this.showCiState data.status
        if data.coverage
          this.showCiCoverage data.coverage
      , 'json'

  showCiState: (state) ->
    $('.ci_widget').hide()
    allowed_states = ["failed", "canceled", "running", "pending", "success", "skipped", "not_found"]
    if state in allowed_states
      $('.ci_widget.ci-' + state).show()
      switch state
        when "failed", "canceled", "not_found"
          @setMergeButtonClass('btn-danger')
        when "running", "pending"
          @setMergeButtonClass('btn-warning')
    else
      $('.ci_widget.ci-error').show()
      @setMergeButtonClass('btn-danger')

  showCiCoverage: (coverage) ->
    text = 'Coverage ' + coverage + '%'
    $('.ci_widget:visible .ci-coverage').text(text)

  setMergeButtonClass: (css_class) ->
    $('.accept_merge_request').removeClass("btn-create").addClass(css_class)
