
include_attribute "ocean"

default[:metrics_service][:app_name]      = "metrics_service"
default[:metrics_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.metrics_service.app_name}"

default[:metrics_service][:shared_dirs]   = ["log"]
default[:metrics_service][:extra_shared_dirs] = []


default[:metrics_service][:async_workers_dir] = "/var/run/async_workers"
