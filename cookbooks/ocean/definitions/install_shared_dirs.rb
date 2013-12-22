# Create the extra directories inside the shared directory

define :ocean_install_shared_dirs, :s => nil do

  s = params[:s]
  (s[:shared_dirs] + s[:extra_shared_dirs]).each do |dir|
    directory "#{s[:app_dir]}/shared/#{dir}" do
      recursive true
      owner node[:ocean][:rails_deploy_user]
      group node[:ocean][:rails_deploy_group]
      mode "0755"
    end
  end

end
