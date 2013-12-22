name "base"
description "The base role which should be included on all machines managed by Chef, " +
            "regardless of whether they are servers or developer machines."

run_list ["recipe[ocean]",
          "recipe[ntp]",
          "recipe[chef-client::config]",
          "recipe[chef-client::service]",
          "recipe[logrotate::global]"
         ]

# # Don't run the service recipe or install NTP on dev machines
# env_run_lists({"dev"      => ["recipe[chef-client::config]"],
#                "_default" => []})


default_attributes(
  "ntp" => { "servers" => ["ntp.kth.se", "ntp.lth.se", "ntp.uu.se",
                           "ntp1.chalmers.se", "ntp2.chalmers.se",
                           "ntp1.sth.netnod.se", "ntp2.sth.netnod.se"]
           }
)
