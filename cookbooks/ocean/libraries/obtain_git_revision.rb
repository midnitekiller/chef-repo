require 'net/http' 

class Chef::Recipe::Git
  
  def self.get_revision(b, branch, ocean)
    # Always deploy the last commit in the prod branch
    return branch if branch == "prod"

    # We need the last successful non-personal build in the branch for all other environments
    build_locator = "status:SUCCESS,branch:#{branch},personal:false"
    # Prepare to call the TeamCity server
    url = URI.parse("#{ocean[:teamcity_server_url]}/app/rest/buildTypes/id:#{b['tc_config_id']}/builds/#{build_locator}")
    req = Net::HTTP::Get.new(url.path)
    req.basic_auth ocean[:teamcity_username], ocean[:teamcity_password]

    # Do the call
    begin
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    rescue
      raise "HTTP request to TeamCity failed (#{url})"
    end

    m = res.body.match(/revision version=\"([0-9a-f]{32,}+)\"/)
    raise "No successful, non-personal TeamCity builds available on the #{branch} branch" unless m

    # Return the matched revision number
    m[1]
  end

end
