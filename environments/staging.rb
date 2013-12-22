name "staging"
description "The 'staging' branch environment: the next release QA environment."

#cookbook_versions
cookbook "riak", "= 1.3.0"

default_attributes(
  "chef_client" => { "init_style"       => "upstart",
                     "daemon_options"   => ["--fork"],
                     "interval"         => 1800
                   }
)
