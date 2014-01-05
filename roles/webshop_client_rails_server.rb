name "webshop_client_rails_server"
description "A machine running a deployed Rails webshop_client application."

run_list ["role[rails_server]",
          "recipe[nodejs]",             # Node.js (only for its JS runtime)
          "recipe[webshop_client::rails]"
         ]
