name "master"
description "The 'master' branch environment: general development."

#cookbook_versions
cookbook "riak", "= 1.3.0"

default_attributes(
  "chef_client" => { "init_style"       => "upstart",
                     "daemon_options"   => ["--fork"],
                     "interval"         => 600
                   }
)
