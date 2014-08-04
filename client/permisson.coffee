Meteor.subscribe 'Roles'
Meteor.subscribe 'Permissions'

Template.permissions.events
	"click #addNewRole": (evt, tmpl) ->
		input=tmpl.find("#role")
		role = input.value
		input.value = ''
		Roles.insert 
			"role": role

	"click #addNewPermissions": (evt, tmpl) ->
		input=tmpl.find("#permissions")
		permissions = input.value
		input.value = ''
		Permissions.insert 
			"name": permissions

	"click .permissions-item": (evt, templ) ->
		input = evt.target
		if input.checked
			Roles.update {"_id": Session.get "active_role"},
				"$addToSet":
					"permissions": @name
		else
			Roles.update {"_id": Session.get "active_role"},
				"$pop": 
				 	"permissions": @name


	"mousedown .roles li": (evt, tmpl) ->
		Session.set('active_role', @_id)

	"dblclick .roles li": (evt, tmpl) ->
		Session.set('editing_role', @_id)
		Deps.flush()
		ActivateInput tmpl.find('#input-role') 

	"click .edit-permission": (evt, tmpl) ->
		Session.set 'editing_permission', @_id
		Deps.flush()
		ActivateInput tmpl.find('#input-permission')


	"click .del-role": (evt, tmpl) ->
		if Session.equals 'active_role', @_id
			Session.set 'active_role', null
		Roles.remove
			"_id": @_id

	"click .del-permission": (evt, tmpl) ->
		# Meteor.call "deletePermission", @_id, @name
		name = @name
		Roles.find {"permissions": name} 
			.forEach (item) ->
				Roles.update {"_id": item._id},
		            "$pull":
		                "permissions": name
		            ,
		                "multi": true

		Permissions.remove 
			"_id": @_id

Template.permissions.events OkCancelEvents '#input-role', 
	ok: (value, evt) ->
		if value != @role
			Roles.update @_id,
				"$set":
					"role": value

		Session.set('editing_role', null)

	cancel: (value, evt) ->
		Session.set('editing_role', null)

Template.permissions.events OkCancelEvents '#input-permission', 
	ok: (value, evt) ->
		if(value != @name)
			name = @name
			Permissions.update @_id,
				"$set":
					"name": value

			Roles.find {"permissions": name} 
				.forEach (item) ->
					Roles.update {"_id": item._id},
			            "$pull":
			                "permissions": name
			        Roles.update {"_id": item._id},
			        	"$push":
			                "permissions": value

		Session.set('editing_permission', null)

	cancel: (value, evt) ->
		Session.set('editing_permission', null)

	
Template.permissions.activeClass = ->
	if @_id == Session.get 'active_role' then 'active' else ''

Template.permissions.activeRoleHavePermission = ->
	if Session.get 'active_role'
		permissions = GetActiveRole().permissions
		if permissions 
			permissions.indexOf(@name) != -1
		else
			false
	else
		false

Template.permissions.is_editing_role = ->
	Session.equals 'editing_role', @_id

Template.permissions.is_editing_permission = ->
	Session.equals 'editing_permission', @_id

Session.setDefault('active_role', null)
Session.setDefault('editing_role', null)
Session.setDefault('editing_permission', null)
	

GetActiveRole = ->
	Roles.findOne({"_id": Session.get 'active_role'})

