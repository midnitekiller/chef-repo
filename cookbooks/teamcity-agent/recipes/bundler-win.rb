if platform?("windows")

  execute "TCP 80 rules for bundler" do
    timeout 10
    version = registry_get_values("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", :x86_64).find_all{|item| item[:name] == "CurrentVersion"}[0][:data]

    if version == "5.2" # windows server 2003
      command "netsh firewall set portopening protocol=tcp port=80 name=\"TCP 80\" mode=enable"
    else # Let's hope this works with server 2008 and 2012
      command "netsh advfirewall firewall add rule name=\"TCP 80\" dir=out action=allow protocol=TCP remoteport=80 enable=yes"
    end
  end
  
  execute "TCP 443 rules for bundler" do
    timeout 10
    version = registry_get_values("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", :x86_64).find_all{|item| item[:name] == "CurrentVersion"}[0][:data]

    if version == "5.2" # windows server 2003
      command "netsh firewall set portopening protocol=tcp port=443 name=\"TCP 443\" mode=enable"
    else # Let's hope this works with server 2008 and 2012
      command "netsh advfirewall firewall add rule name=\"TCP 443\" dir=out action=allow protocol=TCP remoteport=443 enable=yes"
    end
  end

  execute "Install bundler" do
      command "#{node['teamcity-agent::ruby-win']['ruby_path']}\\bin\\gem install bundler"
  end
 
else
  Chef::Log.warn('Package can only be installed on the Windows platform using this cookbook.')
end


