name "media_riak_server"
description "Riak database node for serving static assets via Varnish."

run_list ["role[base]",
          "recipe[riak]",
          "recipe[ulimit]"
         ]
    
default_attributes(
  "riak" => { 
    "package" => { "version"    => { "major"       => "1",     # Was 1.2.1
                                     "minor"       => "4", 
                                     "incremental" => "2" 
                                   }
    },
    "config"  => { "riak_search" => { "enabled"    => true 
                                    }
#                  "riak_kv"     => { "storage_backend" => "riak_kv_eleveldb_backend" 
#                                   }
    }
  }
)
