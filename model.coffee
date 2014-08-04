@EdmCategories = new Meteor.Collection("edm_categories")

@Roles = new Meteor.Collection "user_roles"
# @Roles = new Meteor.Collection "user_roles",
# 	schema:
# 		role:
# 			type: String
# 			label: "Role"
# 			max: 20

@Permissions = new Meteor.Collection "permissions"
# @Permissions = new Metetor.Collection "permissions",
# 	schema:
# 		name:
# 			type: String
# 			label: "Permission"
# 			max: 20

Meteor.methods
    deletePermisson: (id, name) ->
        Roles.update {"permissions": name},
            "$pull":
                "permissions": name
            ,
                "multi": true

        Permissions.remove 
            "_id": id


