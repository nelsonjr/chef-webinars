#!/bin/bash

declare -r chef_server='chef-server.c.graphite-demo-chef-webinar1.internal'
declare -r org_name='google'
declare -r chef_server_url="https://${chef_server}/organizations/${org_name}"
declare -r chef_server_crt='gs://chef-webinar1/server.crt'
declare -r validator='gs://chef-webinar1/google-validator.pem'
declare -r start_run_list='["role[webserver]"]'
declare -r local_validator='/etc/chef/validation.pem'
declare -r startup_json='/etc/chef/startup.json'

if [[ -e '/usr/bin/chef-client' ]]; then
  echo '===== Chef already installed. Skipping installation. ====='
else
  echo '===== Installing Chef client ====='
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi

mkdir -p /etc/chef

echo '===== Copying validator key ====='
gsutil cp "${validator}" "${local_validator}"

cat >/etc/chef/client.rb <<EOF
chef_server_url '${chef_server_url}'
validation_client_name '${org_name}-validator'
EOF

echo '===== Setting up security ====='
mkdir -p /etc/chef/trusted_certs
gsutil cp "${chef_server_crt}" "/etc/chef/trusted_certs/server.crt"

echo '===== Setting first run ====='
cat >"${startup_json}" <<EOF
{"run_list": ${start_run_list}}
EOF

echo '===== Converging Chef ====='
chef-client -j /etc/chef/startup.json

echo '===== Cleaning up ====='
echo 'Deleting validator key'
rm -f "${local_validator}"
echo 'Deleting startup role'
rm -f "${startup_json}"
