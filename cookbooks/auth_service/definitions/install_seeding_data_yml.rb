define :install_seeding_data_yml, 
         :app_dir => nil, 
         :app_bag => nil, 
         :chef_env => nil do

  file "#{params[:app_dir]}/shared/seeding_data.yml" do
    owner node[:ocean][:rails_deploy_user]
    group node[:ocean][:rails_deploy_group]
    mode "0644"

    app_name = params[:app_bag]["api_user_name"]

    # ApiUsers ---------------------------------------------
    users = []

    search(:apps, "defines_api_users:*").each do |app|
      app["defines_api_users"].each do |username, data|
        password = data['passwords'][params[:chef_env]]
        data.delete('passwords')
        data['password'] = password
        users << [username, data.to_hash]
      end
    end

    # Services, Resources, Rights --------------------------
    structure = []

    search(:apps, "structure:*").each do |app|
      structure << app["structure"].to_hash
    end

    content({'required_api_users' => users,
             'structure'          => structure}.to_yaml.gsub(/!ruby\/hash:Mash\s+/, ''))

    notifies :run, "execute[update-api-users-and-structure]"
  end

end

