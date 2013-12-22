name "chefserver"
description "The Chef server."

run_list ["recipe[ocean]",
          "recipe[chef-server]",       # The chef-server recipe must precede the chef-client one, otherwise
          "role[base]"                 # its presence can't be detected by the chef-client code.
         ]

# override_attributes(
#   "authorization" => {
#     "sudo" => {
#       "groups"       => ["sysadmin"],
#       "passwordless" => true
#     }
#   }
# )
