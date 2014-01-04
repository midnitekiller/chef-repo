define :ocean_install_ocean_constants_file, :app_dir => nil  do

  if params[:app_dir]
    template "#{params[:app_dir]}/shared/ocean_constants.rb" do
      cookbook "ocean"
      source "ocean_constants.rb.erb"
      owner node[:ocean][:rails_deploy_user]
      group node[:ocean][:rails_deploy_group]
      mode "0644"
      notifies :reload, 'service[apache2]'
    end
  end

end
