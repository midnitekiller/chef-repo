#
# These defaults are based on data read from data bags.
#

ocean_base = Chef::DataBagItem.load("ocean", "base")
ocean_tc   = Chef::DataBagItem.load("ocean", "teamcity")


default[:ocean][:base_domain]         = ocean_base['base_domain']

default[:ocean][:chef_server_url]     = "https://chef.#{node.ocean.base_domain}"

default[:ocean][:rails_deploy_user]   = "www-data"
default[:ocean][:rails_deploy_group]  = "www-data"
default[:ocean][:rails_apps_dir]      = "/srv"

default[:ocean][:teamcity_server_url] = "http://teamcity.#{node.ocean.base_domain}:8111"
default[:ocean][:teamcity_username]   = ocean_tc["teamcity_username"]
default[:ocean][:teamcity_password]   = ocean_tc["teamcity_password"]

