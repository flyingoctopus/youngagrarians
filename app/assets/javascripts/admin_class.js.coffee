class window.Admin
  init: () ->
    _.bindAll @, 'listInit'
    @listInit()


  listInit: () =>
    form = $("#locations-admin-list form")
    console.log "form: ", form
    if form.length > 0
      $("button#edit-all").on 'click', (e) =>
        $("#locations_update_submit_type").val 'edit'

      $("button#delete-all").on 'click', (e) =>
        $("#locations_update_submit_type").val 'delete'

      $("button#approve-all").on 'click', (e) =>
        $("#locations_update_submit_type").val 'approve'
      form.on 'submit', (e) =>
        e.preventDefault()

        type = $("#locations_update_submit_type").val()

        selected = $("input.id:checked")

        ids = []
        selected.each (i,el) ->
          ids.push @.value

        console.log 'got ids: ', ids

        if type == "edit"

          console.log 'need to edit!', window.location.href
        else if type == "delete"
          if confirm 'Are you sure you want to delete all of these?'
            console.log "they're sure!"
          console.log 'need to delete'
        else if type == "approve"
          console.log 'need to approve'