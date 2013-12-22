name "media_rails_server"
description "A machine running a deployed Rails media_service application."

run_list ["role[rails_server]",
          "recipe[media_service::rails]"
         ]
