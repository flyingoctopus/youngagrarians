class Youngagrarians.Views.ResultItem extends Backbone.Marionette.ItemView
  tagName: "li"
  className: "result-item"
  template: "backbone/templates/result-item"

  onBeforeRender: () =>
    @model.on 'change:show', @changeShow
    #console.log 'result item onBeforeRender, model: ', @model

  changeShow: (model) =>
    console.log 'model result item view needs to be hidden: ', model

  onRender: () =>
    #console.log 'result item onRender, model: ', @model