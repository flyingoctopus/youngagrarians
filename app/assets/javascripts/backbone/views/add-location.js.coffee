class Youngagrarians.Views.AddLocation extends Backbone.Marionette.View
  template: 'backbone/templates/add-location'
  className: 'thing'

  events:
    'click button.btn-warning'    : 'cancelAdd'
    'submit form#add-to-map-form' : 'submitForm'
    'change select#category' : 'updateSubcategories'

  initialize: (options) =>
    _.bindAll @, 'render', 'cancelAdd', 'submitForm'

  render: =>
    @$el.html JST[ @template ] @model.toJSON()

    @delegateEvents()
    $("body #modal").html @el

    @$el.find("div.modal.hide.fade").modal 'show'

    select = $("select#category")
    select.append $("<option>")
      .attr("value", -1)
      .html 'Select A Category'

    window.Categories.each (model) =>
      opt = $("<option>")
        .attr( 'value', model.get('id'))
        .html model.get('name')
      select.append opt

  updateSubcategories: (e) =>
    id = parseInt $(e.target).val()
    if id >= 0
      cat = window.Categories.get id
      select = @$el.find("select#subcategory").empty()
      subcats = cat.get('subcategory')

      if subcats.length == 0
        select.prop 'disabled', 'disabled'
      else
        select.prop 'disabled', false
        subcats.each (model) =>
          select.append $("<option>")
            .attr( 'value', model.get("id") )
            .html( model.get( 'name' ) )



  cancelAdd: (e) =>
    e.preventDefault()
    @$el.find("div.modal.hide.fade").modal 'hide'
    _.defer () =>
      @$el.remove()
    true

  submitForm: (e) =>
    e.preventDefault()

    agree = @$el.find("input#agree")
    if agree.is(":checked")
      location = $("input#location").val()
      @model.set 'address', location

      @model.set 'latitude', $.goMap.getMap().center.lat
      @model.set 'longitude', $.goMap.getMap().center.lng

      category = window.Categories.get $("select#category").val()
      @model.set 'category_id', @$el.find("select#category").val()
      @model.set 'category', category

      subcategories = new Youngagrarians.Collections.SubcategoryCollection
      subcatId = $("select#subcategory").val()
      if !_.isNull subcatId
        _(subcatId).each (id) =>
          s = window.Subcategories.get id
          subcategories.add s

      @model.set 'subcategory', subcategories

      @model.set 'bioregion', @$el.find('input#bioregion').val()
      @model.set 'name', @$el.find("input#name").val()
      @model.set 'description', @$el.find('textarea#description').val()
      @model.set 'fb_url', @$el.find('input#facebook').val()
      @model.set 'twitter_url', @$el.find('input#twitter').val()
      @model.set 'url', @$el.find('input#url').val()
      @model.set 'phone', @$el.find('input#phone').val()
      @model.set 'email', @$el.find("input#email").val()

      window.Locations.create @model, wait: true

      @cancelAdd(e)
    else
      alert "You have to agree to the terms!"
