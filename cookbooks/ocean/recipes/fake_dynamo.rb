
# gem_package "fake_dynamo" do
#   action :install
#   version "0.1.3"
# end

# directory "/usr/local/var/fake_dynamo" do
#   owner "www-data"
#   group "www-data"
#   mode 0664
#   action :create
#   recursive true
# end

# execute "Start fake_dynamo" do
#   user "root"
#   group "root"
#   cwd "/usr/local/rvm/gems/ruby-2.0.0-p247@global/gems/fake_dynamo-0.1.3"
#   fake_dynamo = "/usr/local/rvm/gems/ruby-2.0.0-p247@global/bin/fake_dynamo"
#   command "#{fake_dynamo} --port 4567 --db /tmp/fake_dynamo.fdb --daemonize"
# end

remote_file "/tmp/dynamodb_local_2013-12-12.tar.gz" do
  source "https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_2013-12-12.tar.gz"
end

directory "/srv"

bash "install_dynamodb_local" do
  not_if do ::Dir.exists?('/srv/dynamodb_local_2013-12-12') end
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar --no-same-owner -zxf dynamodb_local_2013-12-12.tar.gz
    chown -Rf www-data:www-data dynamodb_local_2013-12-12
    mv dynamodb_local_2013-12-12 /srv
  EOH
end


# java -jar DynamoDBLocal.jar --port 4567