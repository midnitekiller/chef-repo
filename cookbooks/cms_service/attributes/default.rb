
include_attribute "ocean"

default[:cms_service][:app_name]      = "cms_service"
default[:cms_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.cms_service.app_name}"

default[:cms_service][:shared_dirs]   = ["log"]
default[:cms_service][:extra_shared_dirs] = []
