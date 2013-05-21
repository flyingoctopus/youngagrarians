class Youngagrarians.Views.AddLocation extends Backbone.Marionette.View
  template: 'backbone/templates/add-location'
  className: 'thing'
  events:
    'click button.btn-warning'    : 'cancelAdd'
    'submit form#add-to-map-form' : 'submitForm'

  initialize: (options) =>
    _.bindAll @, 'render', 'cancelAdd', 'submitForm'

  render: =>
    @$el.html JST[ @template ] @model.toJSON()

    @delegateEvents()
    $("body #modal").html @el

    @$el.find("div.modal.hide.fade").modal 'show'

    select = $("select#category")
    window.Categories.each (model) =>
      opt = $("<option>")
        .attr( 'value', model.get('id'))
        .html model.get('name')
      select.append opt

  cancelAdd: (e) =>
    e.preventDefault()
    @$el.find("div.modal.hide.fade").modal 'hide'
    _.defer() =>
      @$el.remove()

  submitForm: (e) =>
    e.preventDefault()

    location = $("input#location").val()
    @model.set 'address', location

    $.goMap.setMap
      address: location

    @model.set 'latitude', $.goMap.getMap().center.lat
    @model.set 'longitude', $.goMap.getMap().center.lng

    category = window.Categories.get $("select#category").val()

    @model.set 'category_id', @$el.find("select#category").val()
    @model.set 'category', category
    @model.set 'bioregion', @$el.find('input#bioregion').val()
    @model.set 'name', @$el.find("input#name").val()
    @model.set 'description', @$el.find('textarea#description').val()
    @model.set 'fb_url', @$el.find('input#facebook').val()
    @model.set 'twitter_url', @$el.find('input#twitter').val()
    @model.set 'url', @$el.find('input#url').val()
    @model.set 'phone', @$el.find('input#phone').val()

    window.Locations.create @model, wait: true

    @cancelAdd(e)
