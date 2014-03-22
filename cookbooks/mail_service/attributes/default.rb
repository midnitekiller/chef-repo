
include_attribute "ocean"

default[:mail_service][:app_name]      = "mail_service"
default[:mail_service][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.mail_service.app_name}"

default[:mail_service][:shared_dirs]   = ["log"]
default[:mail_service][:extra_shared_dirs] = []
