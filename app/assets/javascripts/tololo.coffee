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
  
  #connect items with observableArrays
  ko.bindingHandlers.sortableList = {
    init: (element, valueAccessor, allBindingsAccessor, viewModel, context) ->
      $(element).data("sortList", valueAccessor()) #attach meta-data
      $(element).sortable({
        connectWith: '.sortContainer',
        update: (event, ui) ->
          item = ui.item.data("sortItem")
          return false if item.content == ''
          if (item) 
            #identify parents
            originalParent = ui.item.data("parentList")
            newParent = ui.item.parent().data("sortList")
            #figure out its new position
            position = ko.utils.arrayIndexOf(ui.item.parent().children(), ui.item[0])
            if (position >= 0) 
              originalParent.remove(item)
              newParent.splice(position, 0, item)
            ui.item.remove()
      })
  }
  class List
    constructor: (data) ->
      self = this
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
