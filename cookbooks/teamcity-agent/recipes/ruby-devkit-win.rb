if platform?("windows")

  devkit_parent_path = node['teamcity-agent::ruby-devkit-win']['devkit_parent_path'] 
  devkit_path = "#{devkit_parent_path}devkit"

  directory devkit_path do
    :create
    not_if {::File.directory?(devkit_path)}
  end

  remote_file "#{devkit_path}\\devkit.exe" do
    source node['teamcity-agent::ruby-devkit-win']['devkit_url']
    not_if {::File.directory?(devkit_path+ "\\bin")}
  end

  execute "un7zip devkit" do
      command "cd #{devkit_path} & c:\\7-zip\\7z.exe x -y *.exe" 
  end

  execute "init devkit" do
      command "cd #{devkit_path} & ruby dk.rb init" 
  end

  execute "install devkit" do
      command "cd #{devkit_path} & ruby dk.rb install" 
  end
 
else
  Chef::Log.warn('Package can only be installed on the Windows platform using this cookbook.')
end

