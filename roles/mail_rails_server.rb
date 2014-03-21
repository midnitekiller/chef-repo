name "mail_rails_server"
description "A machine running a deployed Rails mail_service application."

run_list ["role[rails_server]",
          "recipe[mail_service::rails]"
         ]
