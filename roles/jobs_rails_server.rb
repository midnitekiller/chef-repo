name "jobs_rails_server"
description "A machine running a deployed Rails jobs_service application."

run_list ["role[rails_server]",
          "recipe[jobs_service::rails]"
         ]
