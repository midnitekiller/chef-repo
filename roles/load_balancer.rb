name "load_balancer"
description "Load balancing of all incoming HTTP requests (80 => 80)."

run_list ["role[base]",
          "recipe[apt]",
          "recipe[varnish::apt_repo]",
          "recipe[varnish]"
         ]

default_attributes(
  "varnish" => {
    "version"          => "3.0",
    "storage"          => 'malloc',
    "storage_size"     => "3G",       # Leave some space for the OS
    "min_threads"      => 800,        # 800 / number of cores
    "max_threads"      => 4000,       # Total for all thread pools (should be < 5000)
    "ttl"              => 0,
    "listen_address"   => '',
    "listen_port"      => 80,
    "ban_lurker_sleep" => 0.01        # Enable the ban lurker
  }
)

# m1.medium (1 core, 3.75 GB RAM, $0.130 per hour):
#    storage_size: 3G
#    min_threads:  800

# c3.large (2 cores, 3.75 GB RAM, $0.171 per hour): RECOMMENDED
#    storage_size: 3G
#    min_threads:  400

# m1.large (2 cores, 7.5 GB RAM, $0.260 per hour):
#    storage_size: 6G
#    min_threads:  400
