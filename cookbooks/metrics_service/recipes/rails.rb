#
# Cookbook Name:: metrics_service
# Recipe:: rails
#
# Copyright 2014, Peter Bengtson
#
# All rights reserved - Do Not Redistribute
#

s = node[:metrics_service]                          # Node (s)ervice data
b = data_bag_item("apps", s[:app_name])             # "apps" data (b)ag
branch = node.chef_environment                      # Deployment envs are named after their branches
db_config = b['db'] && b['db'][branch]              # Hash of DB config data

# Git data
git_repo =       b['repo_url']
git_deploy_key = b['repo_private_key']
git_rev =        Git.get_revision(b, branch, node[:ocean])
node.set[s[:app_name]][:git_revision] = git_rev
node.set[s[:app_name]][:git_branch] = branch

# The following is found in the ocean cookbook
ocean_install_missing_ubuntu_libs

# Get rid of the globally installed rake
file "/usr/local/bin/rake" do  
  action :delete
end 

ocean_install_shared_dirs do
  s s
end

ocean_install_ocean_constants_file do
  app_dir s[:app_dir]
end

ocean_install_config_yml do 
  app_dir  s[:app_dir]
  app_bag  b
  chef_env branch
end

ocean_install_aws_yml do
  app_dir s[:app_dir]
end


# Deploy the application
application s[:app_name] do
  action b['force_deploy'] ? :force_deploy : :deploy
  rollback_on_error true
  
  repository git_repo
  revision git_rev
  shallow_clone true
  enable_submodules true

  path s[:app_dir]
  owner node[:ocean][:rails_deploy_user]
  group node[:ocean][:rails_deploy_group]
  
  environment_name "production"      # Used in all deployed envs
  
  purge_before_symlink [".git", ".gitignore", ".idea", ".rspec", 
                        "doc", "log", "README.rdoc", "MIT-LICENSE", "spec",
                        "config/initializers/ocean_constants.rb",
                        "config/config.yml", "config/aws.yml"
                        ]

  create_dirs_before_symlink ["tmp"]

  symlink_before_migrate({"log"                => "log",
                          "ocean_constants.rb" => "config/initializers/ocean_constants.rb",
                          "config.yml"         => "config/config.yml", 
                          "aws.yml"            => "config/aws.yml"
                         })
  
  rails do
    gems ['bundler']
    bundler true
    bundler_deployment true
    database(db_config) if db_config
  end
  
  migration_command "bundle exec rake db:create RAILS_ENV=production; bundle exec rake db:migrate RAILS_ENV=production"
  migrate true if db_config

  passenger_apache2 do
    webapp_template "rails_service.conf.erb"
    params(:app_dir => s[:app_dir])
  end
  
end


# Logrotate
logrotate_app "rails_app" do
  cookbook   "logrotate"
  path       "#{s[:app_dir]}/shared/log/*.log"
  frequency  "daily"
  rotate     30
  options    ["missingok", "copytruncate", "compress", "delaycompress", "notifempty"]
end

