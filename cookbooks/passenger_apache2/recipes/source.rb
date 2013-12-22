#
# Cookbook Name:: passenger_apache2
# Recipe:: source
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

include_recipe "build-essential"

node.default['passenger']['apache_mpm']  = 'prefork'


case node['platform_family']
when "arch"
  package "apache"
when "rhel"
  package "httpd-devel"
  if node['platform_version'].to_f < 6.0
    package 'curl-devel'
  else
    package 'libcurl-devel'
    package 'openssl-devel'
    package 'zlib-devel'
  end
else
  apache_development_package =  if %w( worker threaded ).include? node['passenger']['apache_mpm']
                                  'apache2-threaded-dev'
                                else
                                  'apache2-prefork-dev'
                                end
  %W( #{apache_development_package} libapr1-dev libcurl4-gnutls-dev ).each do |pkg|
    package pkg do
      action :upgrade
    end
  end
end


# -------------------------------------------------------------------
# Begin song and dance to install Passenger in the right place
# -------------------------------------------------------------------

o = ohai "reload" do
  action     :nothing
end

g = gem_package "passenger" do
  version    node['passenger']['version']
  gem_binary "#{node['languages']['ruby']['bin_dir']}/gem"
  options    "--no-ri --no-rdoc"
  action     :nothing
end

m = execute "passenger_module" do
  command    "#{node['languages']['ruby']['ruby_bin']} #{node['passenger']['root_path']}/bin/passenger-install-apache2-module _#{node['passenger']['version']}_ --auto"
  creates    node['passenger']['module_path']
  action     :nothing
end


ruby_block "install passenger in new ruby" do
  block do
    # Reload Ohai so Ruby changes are picked up
    o.run_action(:reload)
    node.default['passenger']['root_path']   = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['passenger']['version']}"
    node.default['passenger']['module_path'] = "#{node['passenger']['root_path']}/#{Chef::Recipe::PassengerConfig.build_directory_for_version(node['passenger']['version'])}/apache2/mod_passenger.so"
    node.default['passenger']['ruby_bin']    = node['languages']['ruby']['ruby_bin']
    puts "----------------------------------------------------------------"
    puts "ruby bin_dir is now          #{node['languages']['ruby']['bin_dir']}"
    puts "passenger root_path is now   #{node['passenger']['root_path']}"
    puts "passenger module_path is now #{node['passenger']['module_path']}"
    puts "passenger ruby_bin is now    #{node['passenger']['ruby_bin']}"
    puts "----------------------------------------------------------------"

    # Install the passenger gem
    g.gem_binary "#{node['languages']['ruby']['bin_dir']}/gem"
    g.run_action(:install)

    # Execute the passenger install script in the newly installed passenger gem
    m.command "#{node['passenger']['ruby_bin']} #{node['passenger']['root_path']}/bin/passenger-install-apache2-module _#{node['passenger']['version']}_ --auto"
    m.creates node['passenger']['module_path']
    m.run_action(:run)
  end
  action :create
end
# -------------------------------------------------------------------
# End song and dance to install Passenger in the right place
# -------------------------------------------------------------------
