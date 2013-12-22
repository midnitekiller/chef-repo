if platform?("windows")
    version = registry_get_values("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", :x86_64).find_all{|item| item[:name] == "CurrentVersion"}[0][:data]
    agent_path = node['teamcity-agent']['win_agent_path'] 
    admin_password = node['teamcity-agent']['administrator-password'] 

    agent_name = node['teamcity-agent']['agent_name'] 
    if agent_name.eql?"agent-1"
      agent_name = "agent-#{Random.rand(10000...99999)}"
    end

    java_path = node['teamcity-agent']['java_path']
    server_url = node.ocean.teamcity_server_url

    windows_zipfile agent_path do
      FileUtils.mkdir_p(agent_path) 
      source "#{server_url}/update/buildAgent.zip"
      action :unzip
      not_if {::File.directory?("#{agent_path}\\bin")}
    end

    # Add teamcity url and agent name to the teamcity config file
    ruby_block "configure buildAgent" do
      block do
          rc = Chef::Util::FileEdit.new(agent_path + "\\conf\\buildAgent.dist.properties")
          rc.search_file_replace_line(/^serverUrl=http:\/\/localhost:8111\/$/,
              "serverUrl=#{server_url}")
          rc.search_file_replace_line(/^name=$/,
              "name=#{agent_name}")
          rc.write_file
          FileUtils.cp("#{agent_path}\\conf\\buildAgent.dist.properties","#{agent_path}\\conf\\buildAgent.properties") 
      end
      only_if { File.exists?(agent_path + "\\conf\\buildAgent.dist.properties") }
    end

    # Add java path to the configuration file of the windows service
    ruby_block "configure win service" do
      block do
          rc = Chef::Util::FileEdit.new(agent_path + "\\launcher\\conf\\wrapper.conf")
          rc.search_file_replace_line(/^wrapper.java.command=java$/,
              "wrapper.java.command=#{java_path}")
          rc.write_file
      end
      only_if { File.exists?(agent_path + "\\launcher\\conf\\wrapper.conf") }
    end

    # Add incoming and outgoing firewall rules for teamcity
    execute "TCP 9090 rules for TeamcityAgent" do
      timeout 10
      if version == "5.2" # windows server 2003
        command "netsh firewall set portopening protocol=tcp port=9090 name=\"TCP 9090\" mode=enable"
      else # Let's hope this works with server 2008 and 2012
        command "netsh advfirewall firewall add rule name=\"TCP 9090\" dir=in action=allow protocol=TCP localport=9090 enable=yes"
      end
    end
    
    execute "TCP 8111 rules for TeamcityAgent" do
      timeout 10
      if version == "5.2" # windows server 2003
        command "netsh firewall set portopening protocol=tcp port=8111 name=\"TCP 8111\" mode=enable"
      else # Let's hope this works with server 2008 and 2012
        command "netsh advfirewall firewall add rule name=\"TCP 8111\" dir=out action=allow protocol=TCP remoteport=8111 enable=yes"
      end
    end

    execute "Install service" do
      command "cd c:\\tc\\bin && c:\\tc\\bin\\service.install.bat"
      returns [0,1] # Expect code 1 if the service already exists
    end

    execute "Run service as administrator for windows 2003" do
      if version == "5.2" # windows server 2003
        command "sc.exe config TCBuildAgent obj= .\Administrator password= #{admin_password} type= own"
      end
    end

    execute "Start service" do
      command "cd c:\\tc\\bin && c:\\tc\\bin\\service.start.bat"
      returns [0,1] # Expect 1 if teamcity is running
    end
else
  Chef::Log.warn("Currenty this cookbook only supports windows.")
end
