name "dev"
description "The development environment, used on local developer machines."

#cookbook_versions
cookbook "riak", "= 1.3.0"

default_attributes(
  "chef_client" => { # Developers run 'sudo chef-client' manually as they need
                   },
  # RVM is essential (but it may also have been installed by other means)
  "rvm" =>        { "default_ruby"      => "ruby-2.0.0-p247",
                    "user_default_ruby" => "ruby-2.0.0-p247",
                    "branch"            => "stable",
                    "global_gems"       => [{'name' => 'bundler'}, {'name' => 'chef'}]
                  }
)

#override_attributes
