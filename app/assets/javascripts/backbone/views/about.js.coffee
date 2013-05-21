class Youngagrarians.Views.About extends Backbone.Marionette.View
  template: 'backbone/templates/about'
  className: 'thing'

  events:
    'click button.btn-warning'    : 'close'

  initialize: (options) =>
    _.bindAll @, 'render', 'close'

  render: =>
    @$el.html JST[ @template ] {}

    @delegateEvents()
    $("body #modal").html @el

    @$el.find("div.modal.hide.fade").modal 'show'

  close: (e) =>
    e.preventDefault()
    @$el.find("div.modal.hide.fade").modal 'hide'
    _.defer() =>
      @$el.remove()
