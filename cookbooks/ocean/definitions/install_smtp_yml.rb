define :ocean_install_smtp_yml, 
         :app_dir => nil, 
         :app_bag => nil do

  file "#{params[:app_dir]}/shared/smtp.yml" do
    owner node[:ocean][:rails_deploy_user]
    group node[:ocean][:rails_deploy_group]
    mode "0644"

    smtp = params[:app_bag]['smtp']

    cfg = {}

    cfg['smtp'] = {
        address:        smtp['address'],
        port:           smtp['port'],
        user_name:      smtp['user_name'],
        password:       smtp['password'],
        authentication: smtp['authentication'].to_sym
    }

    content cfg.to_yaml

    notifies :reload, 'service[apache2]'
  end

end
