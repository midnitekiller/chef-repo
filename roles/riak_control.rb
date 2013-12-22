name "riak_control"
description "Riak database node with Riak Control enabled."

run_list []
    
default_attributes(
  "riak" => { 
    "config"  => { "riak_control" => { "enabled" => true
                                     }
    }
  }
)
