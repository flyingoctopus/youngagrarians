class window.Admin
  init: () ->
    _.bindAll @, 'listInit'
    @listInit()
    @editInit()

    @categories = new Youngagrarians.Collections.CategoriesCollection()
    @categories.fetch
      reset: true

  editInit: () =>
    editForm = $(".edit-location")
    if editForm.length > 0
      editForm.each (i,el) =>
        console.log "i: ", i
        console.log "el: ", el

        catSelect = $(el).find("select.category-select")

        if catSelect.length > 0
          catSelect.on 'change', (ev) =>
            ev.preventDefault()
            @populateSubcats( $(ev.target).val(), el )

  populateSubcats: (cat_id, el) =>
    category = @categories.get cat_id
    subcategories = category.get 'subcategory'

    select = $(el).find("select.subcategory")
    select.empty()

    subcategories.each (sc) =>
      opt = $("<option>").val sc.id
      opt.text sc.get('name')
      select.append opt


  listInit: () =>
    form = $("#locations-admin-list form#locations-form")
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

        if type == "edit"
          url = window.location.href + "/" + ids.join(',') + "/multi-edit"
          window.location.href = url
        else if type == "delete"
          if confirm 'Are you sure you want to delete all of these?'
            $.ajax
              type: "POST"
              url: "/~youngagr/map/locations/" + ids.join(",") + "/multi-delete"
              data:
                _method: "DELETE"
                ids: ids
              success: (data,status,xhr) ->
                window.location.reload true

        else if type == "approve"
          $.ajax
            type: "POST"
            url: "/~youngagr/map/locations/" + ids.join(",") + "/approve"
            data:
              ids: ids
            success: (data,status,xhr) ->
              window.location.reload true
