name "infra"
description "The environment used for infrastructure: chef, etc."

#cookbook_versions
cookbook "mysql", "= 1.2.6"             # 1.3.0 makes TeamCity very sad
cookbook "riak", "= 1.3.0"


default_attributes(
  "chef_client" => { "init_style"       => "upstart",
                     "daemon_options"   => ["--fork"],
                     "interval"         => 1800
                   }
)

#override_attributes
