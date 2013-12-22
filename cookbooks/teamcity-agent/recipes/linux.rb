if platform_family?("debian")
    agent_path = node['teamcity-agent']['linux_agent_path'] 

    agent_name = node['teamcity-agent']['agent_name'] 
    if agent_name.eql?"agent-1"
      agent_name = "agent-#{Random.rand(10000...99999)}"
    end

    java_path = node['teamcity-agent']['java_path']
    server_url = node.ocean.teamcity_server_url

    directory agent_path do
        action :create
    end

    remote_file "Download buildAgent.zip" do 
      path "#{agent_path}/buildAgent.zip"
      source "#{server_url}/update/buildAgent.zip"
      backup false
    end

    package "unzip" do 
      action :install
    end

    execute "Unzip buildAgent.zip" do
      command "unzip -o #{agent_path}/buildAgent.zip -d #{agent_path}"
    end

    ruby_block "Configure buildAgent" do
      block do
          rc = Chef::Util::FileEdit.new("#{agent_path}/conf/buildAgent.dist.properties")
          rc.search_file_replace_line(/^serverUrl=http:\/\/localhost:8111\/.+/,
              "serverUrl=#{server_url}")
          rc.search_file_replace_line(/^name=.+/,
              "name=#{agent_name}")
          rc.write_file
          FileUtils.cp("#{agent_path}/conf/buildAgent.dist.properties","#{agent_path}/conf/buildAgent.properties") 
      end
      not_if { File.exists?(agent_path + "/conf/buildAgent.properties") }
    end

    execute "chmod +x agent.sh" do
      command "chmod +x #{agent_path}/bin/agent.sh"
    end
    
    execute "run agent.sh" do
      # Only run if is not already running
      command "sudo kill -0 $(cat #{agent_path}/logs/buildAgent.pid) || sudo ./#{agent_path}/bin/agent.sh start"
    end

else
  Chef::Log.warn("Only runs in debian family OSes.")
end
