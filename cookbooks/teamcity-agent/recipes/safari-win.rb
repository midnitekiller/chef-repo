if platform?("windows")
    windows_package "Safari 5.1.7" do
        source node['teamcity-agent::safari-win']['http_url']
        installer_type :custom
        action :install
    end
else
  Chef::Log.warn('Safari can only be installed on the Windows platform using this cookbook.')
end


