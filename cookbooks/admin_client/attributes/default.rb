include_attribute "ocean"

default[:admin_client][:app_name]      = "admin_client"
default[:admin_client][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.admin_client.app_name}"

default[:admin_client][:shared_dirs]   = ["log"]
default[:admin_client][:extra_shared_dirs] = []
