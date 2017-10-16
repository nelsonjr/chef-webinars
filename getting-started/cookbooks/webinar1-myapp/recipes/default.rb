# Copyright 2017 Google Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Configures the sample application for the Chef Webinar.

include_recipe 'apache2'
include_recipe 'apache2::mod_php'

ohai_hint 'gce'

apache_module 'php5' do
  filename 'libphp5.so'
end

# TODO(jj): Figure out how to correctly enable this nicely
link '/etc/httpd/mods-enabled/php.conf' do
  to '/etc/httpd/mods-available/php.conf'
  notifies :reload, 'service[apache2]'
end

web_app 'myapp' do
  server_name node['hostname']
  server_aliases [node['fqdn'], "my-site.example.com"]
  docroot '/opt/myapp'
  cookbook 'webinar1-myapp'
end

directory '/opt/myapp' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "/opt/myapp/index.php" do
  source "index.php.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

cookbook_file '/opt/myapp/logo.png' do
  source 'myapp/v1/logo.png'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
