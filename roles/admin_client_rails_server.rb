name "admin_client_rails_server"
description "A machine running a deployed Rails admin_client application."

run_list ["role[rails_server]",
          "recipe[nodejs]",             # Node.js (only for its JS runtime)
          "recipe[admin_client::rails]"
         ]
