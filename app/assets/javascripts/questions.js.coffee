$ ->
  $("#questionTable").sortable
    axis: "y"
    items: ".item"
    stop: (e, ui) ->
      ui.item.children("td").effect "highlight", {}, 1000

    update: (e, ui) ->
      id = ui.item.data("item-id")
      position = ui.item.index()
      $.ajax
        type: "POST"
        url: $(this).data("update-url")
        dataType: "json"
        data:
          id: id
          question:
            position_position: position
