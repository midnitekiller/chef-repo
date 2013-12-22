
include_attribute "ocean"

default[:media_service][:app_name]      = "media_service"
default[:media_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.media_service.app_name}"

default[:media_service][:shared_dirs]   = ["log"]
default[:media_service][:extra_shared_dirs] = []
