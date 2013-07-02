class Youngagrarians.Views.Search extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/search"

  id: "search-form-container"
  className: "form-horizontal"

  events:
    'submit form#search-form': 'doMapSearch'
    'click button#start-search': 'doMapSearch'
    'click a#map-search-clear' : 'clearSearch'

  initialize: (options) =>
    @app = options.app

  doMapSearch: (e) =>
    e.preventDefault()
    terms = @$el.find("input#search").val()

    if terms == ''
      @$el.find("span.alert").slideDown()
      slideUp = () =>
        @$el.find("span.alert").slideUp()
      _.delay slideUp, 4000
    else
      @app.vent.trigger "search:started", terms


  clearSearch: (e) =>
    @$el.find("input#search").val ''
    @app.vent.trigger "search:clear", ''
