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
				"$push":
					"permissions": @name
		else
			Roles.update {"_id": Session.get "active_role"},
				"$pop": 
					"permissions": @name


	"mousedown .roles li": (evt, tmpl) ->
		Session.set('active_role', @_id)

	"dblclick .roles li": (evt, tmpl) ->
		Session.set('edit_role', @_id)
		Deps.flush()
		ActivateInput tmpl.find('#input-role') 

	"click .del-role": (evt, tmpl) ->
		if Session.equals 'active_role', @_id
			Session.set 'active_role', null
		Roles.remove(@_id)

	"click .del-permission": (evt, tmpl) ->
		Permissions.remove(@_id)

Template.permissions.events OkCancelEvents '#input-role', 
	ok: (value, evt) ->
		Roles.update @_id,
			"$set":
				"role": value

		Session.set('edit_role', null)

	cancel: (value, evt) ->
		Session.set('edit_role', null)

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

Template.permissions.is_editing = ->
	Session.equals 'edit_role', @_id


Session.setDefault('active_role', null)
	

GetActiveRole = ->
	Roles.findOne({"_id": Session.get 'active_role'})

