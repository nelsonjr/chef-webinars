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

::Chef::Resource.send(:include, Google::Functions)

machine_name = if node.default.key?('instance-name')
                 # Use a fixed instance name specified via attributes
                 node.default['instance-name']
               else
                 "webinar-#{Time.now.strftime('%Y%m%d')}"
               end
puts "Instance name: #{machine_name}"

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

gcompute_instance machine_name do
  action :create
  machine_type 'n1-standard-1'
  disks [
    {
      boot: true,
      # Auto delete will prevent disks from being left behind on deletion.
      auto_delete: true,
      initialize_params: {
        disk_size_gb: 50,
        source_image: gcompute_image_family('centos-7', 'centos-cloud')
      }
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
        # Enable Cloud Storage so we can access the bootstrap.sh startup script
        # and related files.
        'https://www.googleapis.com/auth/devstorage.read_only'
      ]
    }
  ]
  metadata ({ items: [
    # The recipes/roles to apply to the newly created machine
    { key: 'runlist', value: 'recipe[webinar1-myapp]' },
    # The bootstrap script that will connect the machine and Chef Server
    { key: 'startup-script-url', value: 'gs://chef-webinar1/bootstrap.sh' },
    # The base URL to the Chef Server
    { key: 'chef-server', value: 'chef-demo.graphite.cloudnativeapp.com' },
    # The organization name that this machine will belong to
    { key: 'org-name', value: 'google' },
    # An optional Chef Server certificate (useful for servers with self-signed
    # or untrusted ceritificates). For more information see SECURITY.md page.
    { key: 'chef-server-crt', value: 'gs://chef-webinar1/server.crt' },
    # The validation key to be used to register the machine with Chef Server
    { key: 'validator-key', value: 'gs://chef-webinar1/google-validator.pem' }
  ]})
  tags ({ items: [
    # Default firewall rule only allows HTTP access to machines with
    # http-server tag attached to them.
    'http-server'
  ]})
  zone 'us-west1-a'
  project 'graphite-demo-chef-webinar1'
  credential 'mycred'
end
