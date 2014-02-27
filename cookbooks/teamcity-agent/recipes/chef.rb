if platform?("windows")
  admin_password = node['teamcity-agent']['administrator-password'] 

  # Teamcity agents needs to have the chef service enabled for automatic convergation
  execute "enable chef service" do
    command "chef-service-manager -a install"
  end

  execute "give administrator rights to the chef service" do
    command "sc.exe config chef-client obj= .\\Administrator password= #{admin_password} type= own"
  end
end
