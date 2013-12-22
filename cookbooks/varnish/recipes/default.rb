# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Copyright 2008-2009, Joe Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "varnish"

# Iterate through all apps, collecting web servers, etc
apps = {}
search(:apps, "*:*").each do |app|
  apps[app] = search(:node, "chef_environment:#{node.chef_environment} AND role:#{app['web_server_role']}")
end

# Get the Riak nodes which require special routing
riak_media_nodes = search(:node, "chef_environment:#{node.chef_environment} AND role:media_riak_server")

# Get the subnets Varnish should allow for PURGE and BAN
vbag = data_bag_item("ocean", "varnish")
allow_ban_subnets = vbag["subnets"][node.chef_environment] + vbag["local_network"]

template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  if node['varnish']['vcl_cookbook']
    cookbook node['varnish']['vcl_cookbook']
  end
  owner "root"
  group "root"
  mode 0644
  variables(apps: apps, riak_media_nodes: riak_media_nodes, allow_ban_subnets: allow_ban_subnets)
  notifies :restart, "service[varnish]"
end

template node['varnish']['default'] do
  source "custom-default.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
