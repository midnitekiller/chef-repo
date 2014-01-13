
include_attribute "ocean"

default[:jobs_service][:app_name]      = "jobs_service"
default[:jobs_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.jobs_service.app_name}"

default[:jobs_service][:shared_dirs]   = ["log"]
default[:jobs_service][:extra_shared_dirs] = []


default[:jobs_service][:async_workers_dir] = "/var/run/async_workers"
