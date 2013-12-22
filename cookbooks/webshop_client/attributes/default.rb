include_attribute "ocean"

default[:webshop_client][:app_name]      = "webshop_client"
default[:webshop_client][:app_dir]       = "#{node.ocean.rails_apps_dir}/#{node.webshop_client.app_name}"

default[:webshop_client][:shared_dirs]   = ["log"]
default[:webshop_client][:extra_shared_dirs] = []
