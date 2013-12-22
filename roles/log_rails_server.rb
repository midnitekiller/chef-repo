name "log_rails_server"
description "A machine running a deployed Rails log_service application."

run_list ["role[rails_server]",
          "recipe[log_service::rails]"
         ]
