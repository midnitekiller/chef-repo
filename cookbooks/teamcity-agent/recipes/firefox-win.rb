if platform?("windows")
    windows_package "Mozilla Firefox 25.0b3 (x86 en-US)" do
        source node['teamcity-agent::firefox-win']['http_url']
        installer_type :custom
        options "-ms"
        action :install
    end
else
  Chef::Log.warn('Firefox can only be installed on the Windows platform using this cookbook.')
end
