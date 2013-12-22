name "auth_rails_server"
description "A machine running a deployed Rails auth_service application."

run_list ["role[rails_server]",
          "recipe[auth_service::rails]"
         ]
