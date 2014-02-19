include_recipe "watir::setup"

    version = registry_get_values("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", :x86_64).find_all{|item| item[:name] == "CurrentVersion"}[0][:data]

if platform?("windows")
  bin_path = node['watir::setup']['path']

  windows_zipfile bin_path do
    source node['watir::ie']['http_url']
    action :unzip
    not_if {File.exists?(bin_path + "\\IEDriverServer.exe")}
  end

  registry_key "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" do
    values [{
      :name => "IsInstalled",
      :type => :dword,
      :data => 00000000 
    }]
    action :create
    recursive true
  end

  # Disable IE Security enhanced mode
  registry_key "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" do
    values [{
      :name => "IsInstalled",
      :type => :dword,
      :data => 00000000 
    }]
    action :create
    recursive true
  end

  execute "Make the reg changes appear right now" do
    command "Rundll32 iesetup.dll, IEHardenLMSettings"
    command "Rundll32 iesetup.dll, IEHardenUser"
    command "Rundll32 iesetup.dll, IEHardenAdmin"
  end

  # Disable IE Zone security protections
  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\0" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
    recursive true
  end
  
  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\1" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\3" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\4" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
    recursive true
  end

  # Disable IE first run page
  registry_key "HKEY_CURRENT_USER\\Software\\Policies\\Microsoft\\Internet Explorer\\Main" do
    values [{
      :name => "DisableFirstRunCustomize",
      :type => :dword,
      :data => 2
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main" do
    values [{
      :name => "DisableFirstRunCustomize",
      :type => :dword,
      :data => 2
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main" do
    values [{
      :name => "RunOnceComplete",
      :type => :dword,
      :data => 1
    }]
    action :create
    recursive true
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Internet Explorer\\Main" do
    values [{
      :name => "RunOnceHasShown",
      :type => :dword,
      :data => 1
    }]
    action :create
    recursive true
  end

  execute "Add IEDriverServer to firewall exceptions for windows 2003" do
    command "netsh firewall add allowedprogram #{bin_path}\\IEDriverServer.exe \"IEDriverServer\" ENABLE"
    only_if { version == "5.2" } # windows server 2003
  end

else
  Chef::Log.warn('This recipe only supports windows.')
end
