Router.map -> 
	@route "edm_categories",
		path: "/edm_categories"
		data: ->
			"categories": EdmCategories.find()

	@route "permissions",
		path: '/permissions'
		data: ->
			"permissions": Permissions.find()
			"roles": Roles.find()
			"active_role": Session.get "active_role"
