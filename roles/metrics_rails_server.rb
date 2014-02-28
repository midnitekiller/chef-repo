name "metrics_rails_server"
description "A machine running a deployed Rails metrics_service application."

run_list ["role[rails_server]",
          "recipe[metrics_service::rails]"
         ]
