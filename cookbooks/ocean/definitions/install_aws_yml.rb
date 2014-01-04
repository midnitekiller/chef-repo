define :ocean_install_aws_yml, :app_dir => nil do

  file "#{params[:app_dir]}/shared/aws.yml" do
    owner node[:ocean][:rails_deploy_user]
    group node[:ocean][:rails_deploy_group]
    mode "0644"

    aws = data_bag_item("ocean", "aws")[node.chef_environment]

    cfg = {
      'production' => {
        'access_key_id'     => aws['aws_access_key_id'],
        'secret_access_key' => aws['aws_secret_access_key'],
        'region'            => aws['region'],
        'user_agent_prefix' => 'Ocean'
      }
    }

    content cfg.to_yaml
    
    notifies :reload, 'service[apache2]'
  end

end

