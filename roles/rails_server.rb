name "rails_server"
description "A machine running a deployed Rails application."

run_list ["role[base]",                 # chef-client, NTP, logrotate
          "role[ruby_machine]",         # Ruby
          "recipe[git]",                # Git
          "recipe[passenger_apache2]",  # Apache with Passenger
          #"recipe[nodejs]",            # Node.js (only for its JS runtime)
          #"recipe[mysql::client]",     # MySQL
          "recipe[postgresql::client]", # PostgreSQL
          "recipe[zeromq]"              # ZeroMQ
         ]


override_attributes(

  "apache" => {
    "user"         => "www-data",
    "group"        => "www-data",
    "listen_ports" => [80],
    "timeout"      => 60,        # Service requests time out after one minute
    "contact"      => "someone@example.com"
  },

  "passenger" => {
    "max_pool_size" => 5
  },

  'postgresql' => {
    'version' => "9.3"
  }
)
