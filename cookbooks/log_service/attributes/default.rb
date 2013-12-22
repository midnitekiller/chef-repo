include_attribute "ocean"

default[:log_service][:app_name]           = "log_service"
default[:log_service][:app_dir]            = "#{node.ocean.rails_apps_dir}/#{node.log_service.app_name}"

default[:log_service][:shared_dirs]        = ["log"]
default[:log_service][:extra_shared_dirs]  = []

default[:log_service][:zero_mq_logger_dir] = "/var/run/zeromq_logger"
