define :ocean_install_aws_yml, 
         :app_dir => nil, 
         :app_bag => nil, 
         :chef_env => nil do

  file "#{params[:app_dir]}/shared/aws.yml" do
    owner node[:ocean][:rails_deploy_user]
    group node[:ocean][:rails_deploy_group]
    mode "0644"

    app_name = params[:app_bag]["api_user_name"]

    cfg = {}

    # cfg['APP_NAME'] = app_name
    # cfg['API_USER'] = app_name
    # cfg['API_PASSWORD'] = params[:app_bag]["defines_api_users"][app_name]["passwords"][params[:chef_env]]

    # cfg['BASE_DOMAIN'] = node[:ocean][:base_domain]

    # cfg['LOAD_BALANCERS'] = search(:node, "chef_environment:#{node.chef_environment} AND role:load_balancer").
    #     collect { |node| node.ipaddress }

    # cfg['LOG_HOSTS'] = search(:node, "chef_environment:#{node.chef_environment} AND role:log_rails_server").
    #     collect { |node| node.ipaddress }

    # cfg['API_VERSIONS'] = params[:app_bag]["structure"]["resources"].inject({"_default" => "v1"}) do |acc, x| 
    #   acc[x["name"]] = x["version"]
    #   acc
    # end

    content cfg.to_yaml
  end

end

