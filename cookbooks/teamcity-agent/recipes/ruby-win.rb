if platform?("windows")
    version = registry_get_values("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", :x86_64).find_all{|item| item[:name] == "CurrentVersion"}[0][:data]

  ruby_path = node['teamcity-agent::ruby-win']['ruby_path']

  windows_package "Ruby 2.0.0" do
      source node['teamcity-agent::ruby-win']['ruby_url']
      installer_type :inno
      action :install
  end

  windows_path "#{ruby_path}\\bin" do
    action :add
  end

  execute "Add ruby to firewall exceptions for windows 2003" do
    command "netsh firewall add allowedprogram #{ruby_path}\\bin\\ruby.exe \"Ruby 2.0.0\" ENABLE"
    only_if { version == "5.2" } # windows server 2003
  end

else
  Chef::Log.warn('This package can only be installed on the Windows platform using this cookbook.')
end


