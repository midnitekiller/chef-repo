define :ocean_install_config_yml, 
         :app_dir => nil, 
         :app_bag => nil, 
         :chef_env => nil,
         :extra => nil do

  file "#{params[:app_dir]}/shared/config.yml" do
    owner node[:ocean][:rails_deploy_user]
    group node[:ocean][:rails_deploy_group]
    mode "0644"

    app_name = params[:app_bag]["api_user_name"]

    cfg = {}

    cfg['APP_NAME'] = app_name
    cfg['API_USER'] = app_name
    cfg['API_PASSWORD'] = params[:app_bag]["defines_api_users"][app_name]["passwords"][params[:chef_env]]

    cfg['BASE_DOMAIN'] = node[:ocean][:base_domain]

    cfg['LOAD_BALANCERS'] = search(:node, "chef_environment:#{node.chef_environment} AND role:load_balancer").
        collect { |node| node.ipaddress }

    cfg['LOG_HOSTS'] = search(:node, "chef_environment:#{node.chef_environment} AND role:log_rails_server").
        collect { |node| node.ipaddress }

    acc = {"_default" => "v1"}
    search(:apps, "structure:*").each do |app|
      app["structure"]['resources'].each do |r| 
        acc[r["name"]] = r["version"]
      end
    end
    cfg['API_VERSIONS'] = acc

    params[:extra].each { |k, v| cfg[k] = v } if params[:extra]

    content cfg.to_yaml
  end

end
