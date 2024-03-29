#
# Author:: Noah Kantrowitz <noah@opscode.com>
# Cookbook Name:: application_ruby
# Provider:: rails
#
# Copyright:: 2011-2012, Opscode, Inc <legal@opscode.com>
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

action :before_compile do

  if new_resource.bundler.nil?
    new_resource.bundler new_resource.gems.any? { |gem, ver| gem == 'bundler' }
  end

  unless new_resource.migration_command
    command = "rake db:migrate"
    command = "#{bundle_command} exec #{command}" if new_resource.bundler
    new_resource.migration_command command
  end

  new_resource.environment.merge!({
    "RAILS_ENV" => new_resource.environment_name,
  }) { |k, v1, v2| v1 }  # user's environment settings will override

  if new_resource.use_omnibus_ruby
    Chef::Log.warn("Tying your Application to the Chef Omnibus Ruby is not recommended.")
    new_resource.environment.merge!({
      "PATH" => [Gem.default_bindir, ENV['PATH']].join(':')
    }) { |k, v1, v2| v1 }  # user's environment settings will override
  end

  new_resource.symlink_before_migrate.update({
    "database.yml" => "config/database.yml"
  })


  if new_resource.symlink_logs
    new_resource.purge_before_symlink.push("log")
    new_resource.symlinks.update({"log" => "log"})
  end

end

action :before_deploy do

  new_resource.environment['RAILS_ENV'] = new_resource.environment_name

  install_gems

  create_database_yml

end

action :before_migrate do

  symlink_logs if new_resource.symlink_logs

  if new_resource.bundler
    Chef::Log.info "Running bundle install"
    directory "#{new_resource.path}/shared/vendor_bundle" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
    end
    directory "#{new_resource.release_path}/vendor" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
    end
    link "#{new_resource.release_path}/vendor/bundle" do
      to "#{new_resource.path}/shared/vendor_bundle"
    end
    common_groups = %w{development test cucumber staging production}
    common_groups += new_resource.bundler_without_groups
    common_groups -= [new_resource.environment_name]
    common_groups = common_groups.join(' ')
    bundler_deployment = new_resource.bundler_deployment
    if bundler_deployment.nil?
      # Check for a Gemfile.lock
      bundler_deployment = ::File.exists?(::File.join(new_resource.release_path, "Gemfile.lock"))
    end
    execute "#{bundle_command} install --path=vendor/bundle #{bundler_deployment ? "--deployment " : ""}--without #{common_groups}" do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  else
    # chef runs before_migrate, then symlink_before_migrate symlinks, then migrations,
    # yet our before_migrate needs database.yml to exist (and must complete before
    # migrations).
    #
    # maybe worth doing run_symlinks_before_migrate before before_migrate callbacks,
    # or an add'l callback.
    execute "(ln -s ../../../shared/database.yml config/database.yml && rake gems:install); rm config/database.yml" do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  end

  # This is disabled: even if the rake gem is included in the application's bundle,
  # it somehow isn't recognised. This recipe still tries to install rake, leading
  # to an error as rake already is installed. Where the original install is made is
  # still unclear - I simply can't find it. May be part of the source install. / PB
  #
  gem_names = new_resource.gems.map { |gem, ver| gem }
  if new_resource.migration_command.include?('rake') && !gem_names.include?('rake')
    gem_package "rake" do
      action :install
    end
  end

end

action :before_symlink do

  ruby_block "remove_run_migrations" do
    block do
      if node.role?("#{new_resource.name}_run_migrations")
        Chef::Log.info("Migrations were run, removing role[#{new_resource.name}_run_migrations]")
        node.run_list.remove("role[#{new_resource.name}_run_migrations]")
      end
    end
  end

  if new_resource.precompile_assets.nil?
    new_resource.precompile_assets ::File.exists?(::File.join(new_resource.release_path, "config", "assets.yml"))
  end

  if new_resource.precompile_assets
    command = "rake assets:precompile"
    command = "#{bundle_command} exec #{command}" if new_resource.bundler
    execute command do
      cwd new_resource.release_path
      user new_resource.owner
      environment new_resource.environment
    end
  end

end

action :before_restart do
end

action :after_restart do
end


protected

def bundle_command
  new_resource.bundle_command
end

def install_gems
  new_resource.gems.each do |gem, opt|
    if opt.is_a?(Hash)
      ver = opt['version']
      src = opt['source']
    elsif opt.is_a?(String)
      ver = opt
    end
    gem_package gem do
      action :install
      source src if src
      version ver if ver && ver.length > 0
    end
  end
end

def create_database_yml
  host = new_resource.find_database_server(new_resource.database_master_role)

  template "#{new_resource.path}/shared/database.yml" do
    source new_resource.database_template || "database.yml.erb"
    cookbook new_resource.database_template ? new_resource.cookbook_name.to_s : "application_ruby"
    owner new_resource.owner
    group new_resource.group
    mode "644"
    variables(
      :host => host,
      :database => new_resource.database,
      :rails_env => new_resource.environment_name
    )
  end
end

def symlink_logs
  resource = new_resource

  directory "#{resource.path}/shared/log" do
    owner resource.owner
    group resource.group
  end

  logrotate_app resource.name do
    cookbook "logrotate"
    path "#{resource.path}/shared/#{resource.environment_name}.log"
    frequency "daily"
    rotate 30
    create "666 #{resource.owner} #{resource.group}"
  end
end
