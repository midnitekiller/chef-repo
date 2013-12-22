name "cms_rails_server"
description "A machine running a deployed Rails cms_service application."

run_list ["role[rails_server]",
          "recipe[cms_service::rails]"
         ]
