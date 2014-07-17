Meteor.subscribe "EdmCategories"

#Template
Template.edm_categories.events
	"click #btnAdd": (evt, tmpl) ->
		control = tmpl.find("#category")
		text = control.value 
		control.value = ""
		EdmCategories.insert({name: text})
