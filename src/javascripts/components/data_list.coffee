class DataList extends CustomComponent
  defaults:
    source: []
    data: "{%ROOT%}"
    template: ( itemData ) ->
    paginator:
      tiny: false
      container: null
      total: 0
      defaultPage: 0
    update: ->

__LIB.addComponent "dataList", createComponent(DataList)
