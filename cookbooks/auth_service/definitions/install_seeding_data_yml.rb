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

    # ApiUsers defined in apps have lower priority
    search(:apps, "defines_api_users:*").each do |app|
      app["defines_api_users"].each do |username, data|
        password = data['passwords'][params[:chef_env]]
        data.delete('passwords')
        data['password'] = password
        users << [username, data.to_hash]
      end
    end

    # ApiUsers defined in api_users have higher priority
    search(:api_users, "*:*").each do |u|
      username = u["id"]
      u.delete('id')
      password = u['passwords'][params[:chef_env]]
      u.delete('passwords')
      u['passwords'] = password
      users << [username, u.to_hash]
    end

    # Services, Resources, Rights --------------------------
    structure = []

    search(:apps, "structure:*").each do |app|
      structure << app["structure"].to_hash
    end

    # Roles ------------------------------------------------
    roles = []
    search(:roles, "*:*").each do |r|
      r.delete('id')
      roles << r.to_hash
    end

    # Groups ------------------------------------------------
    groups = []
    search(:groups, "*:*").each do |g|
      g.delete('id')
      groups << g.to_hash
    end

    # Put together the seeding file content ----------------
    content({'required_api_users' => users,
             'structure'          => structure,
             'roles'              => roles,
             'groups'             => groups
            }.to_yaml.gsub(/!ruby\/hash:Mash\s+/, ''))

    # Notify the rake tasks to run, then restart Apache ----
    notifies :run, "execute[update-structure]"
    notifies :reload, 'service[apache2]'
  end

end

