
include_attribute "ocean"

default[:auth_service][:app_name]      = "auth_service"
default[:auth_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.auth_service.app_name}"

default[:auth_service][:shared_dirs]   = ["log"]
default[:auth_service][:extra_shared_dirs] = []
