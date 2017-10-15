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

# Brings the application down and frees all Google Cloud Platform resources.

machine_name = node.default['instance-name']
puts "Instance name: #{machine_name}"

gauth_credential 'mycred' do
  action :serviceaccount
  path '/home/nelsona/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/compute',
    'https://www.googleapis.com/auth/ndev.clouddns.readwrite'
  ]
end

gcompute_zone 'us-west1-a' do
  action :create
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_region 'us-west1' do
  action :create
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_instance machine_name do
  action :delete
  zone 'us-west1-a'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_address "#{machine_name}-ip" do
  action :delete
  region 'us-west1'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gdns_managed_zone 'app-chef-webinar1' do
  action :create
  dns_name 'chef-webinar1.graphite.cloudnativeapp.com.'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gdns_resource_record_set 'www.chef-webinar1.graphite.cloudnativeapp.com.' do
  action :delete
  managed_zone 'app-chef-webinar1'
  type 'A'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end
