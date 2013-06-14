class Youngagrarians.Views.Bioregions extends Backbone.Marionette.ItemView
  template: "backbone/templates/sidebar/bioregions"

  bioregions:
    'bc':
      1: "Northeast"
      2: "Skeena-North Coast"
      3: "Vancouver Island-Coast"
      4: "Caribo-Prince George"
      5: "Thompson-Okanagan"
      6: "Lower Mainland-Southwest"
      7: "Kootenay"

  events:
    'change select#bioregions': 'changeBioregion'

  initialize: (options) =>
    @app = options.app
    @app.vent.on 'province:change', @updateBioregions

  updateBioregions: (data) =>
    province = data.province

    if !_.isNull(province) and !_.isUndefined(province)
      selector = province.toLowerCase()
      bioregions = @bioregions[selector]

      @$el.find("optgroup").remove()

      if !_.isUndefined bioregions
        optgroup = $("<optgroup>")
          .attr( 'id', "bioregions-"+selector )
          .attr( 'label', province+" Bioregions" )
        _(bioregions).each (region,index) ->
          option = $("<option>")
            .attr( 'value', index )
            .text( region )
          optgroup.append option

      @$el.find("select#bioregions").append optgroup


  changeBioregion: (e) =>
    e.preventDefault()
    selectedBioregion = $(e.target).find(":selected")
    if selectedBioregion.val() == "-1"
      @app.vent.trigger "bioregion:change", null
    else
      @app.vent.trigger "bioregion:change", selectedBioregion.text()