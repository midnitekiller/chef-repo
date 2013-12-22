name "ci"
description "The Continuous Integration environment (for all branches)."

#cookbook_versions
cookbook "riak", "= 1.3.0"

default_attributes(
  "chef_client" => { "init_style"       => "upstart",
                     "daemon_options"   => ["--fork"],
                     "interval"         => 1800
                   },
  "rvm" =>        { "default_ruby"      => "ruby-2.0.0-p247",
                    "user_default_ruby" => "ruby-2.0.0-p247",
                    "branch"            => "stable",
                    "global_gems"       => [{'name' => 'bundler'}, {'name' => 'chef'}]
                  }
)

#override_attributes
