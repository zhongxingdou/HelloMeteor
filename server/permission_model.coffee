Meteor.publish 'Roles', () ->
	Roles.find()

Meteor.publish 'Permissions', () ->
	Permissions.find()
