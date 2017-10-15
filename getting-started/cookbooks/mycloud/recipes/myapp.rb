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

# Configures a blank Google Cloud Platform project to deploy the sample
# application.

machine_name = "gannett-#{Time.now.strftime('%s')}"

gauth_credential 'mycred' do
  action :serviceaccount
  path '/home/nelsona/my_account.json'
  scopes [
    'https://www.googleapis.com/auth/compute'
  ]
end

gcompute_zone 'us-west1-a' do
  action :create
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_disk "#{machine_name}-os-1" do
  action :create
  source_image 'projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts'
  zone 'us-west1-a'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_network 'default' do
  action :create
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_region 'us-west1' do
  action :create
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_address "#{machine_name}-ip" do
  action :create
  region 'us-west1'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_machine_type 'n1-standard-1' do
  action :create
  zone 'us-west1-a'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end

gcompute_instance "#{machine_name}" do
  action :create
  machine_type 'n1-standard-1'
  disks [
    {
      boot: true,
      auto_delete: true,
      source: "#{machine_name}-os-1"
    }
  ]
  network_interfaces [
    {
      network: 'default',
      access_configs: [
        {
          name: 'External NAT',
          nat_ip: "#{machine_name}-ip",
          type: 'ONE_TO_ONE_NAT'
        }
      ]
    }
  ]
  service_accounts [
    {
      scopes: [
        'https://www.googleapis.com/auth/devstorage.read_only'
      ]
    }
  ]
  tags ({
    items: [
      'http-server'
    ]
  })
  zone 'us-west1-a'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end
