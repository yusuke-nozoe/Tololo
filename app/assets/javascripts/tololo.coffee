# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  ko.bindingHandlers.sortableItem = {
    init: (element, valueAccessor) ->
      options = valueAccessor()
      $(element).data("sortItem", options.item)
      $(element).data("parentList", options.parentList)
  }
  ko.bindingHandlers.sortableList = {
    init: (element, valueAccessor, allBindingsAccessor, viewModel, context) ->
      $(element).data("sortList", valueAccessor()) #attach meta-data
      $(element).sortable({
        connectWith: '.sortContainer',
        update: (event, ui) ->
          item = ui.item.data("sortItem")
          if (item) 
            return false if item.content == ''
            #identify parents
            originalParent = ui.item.data("parentList")
            newParent = ui.item.parent().data("sortList")
            #figure out its new position
            position = ko.utils.arrayIndexOf(ui.item.parent().children(), ui.item[0])
            if (position >= 0) 
              originalParent.remove(item)
              newParent.cards.splice(position, 0, item)
            ui.item.remove()
            $.ajax({
              type: 'PUT', url: '/tololo/' + item.id, contentType: 'application/json',
              data: ko.toJSON({
                card: { list_id: newParent.id }
              }),
              success: (result) -> console.log result
            })
      })
  }
  class List
    constructor: (data) ->
      self = this
      self.id  = data.id
      self.name  = data.name
      self.cards = ko.observableArray(if data.cards.length > 0 then data.cards else [{content: ''}])

  class TololoViewModel
    constructor: ->
      self = this
      self.lists = ko.observableArray()
      $.get('/tololo/lists', (result) ->
        $.map(JSON.parse(result.lists), (list) ->
          self.lists.push(new List(list))
        )
      )
  ko.applyBindings new TololoViewModel()
