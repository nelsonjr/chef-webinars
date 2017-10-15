#!/bin/bash

metadata() {
  local -r attr=$1
  local -r metadata_ep='http://metadata/computeMetadata/v1beta1/'
  curl -H Metadata-Flavor:Google "${metadata_ep}/instance/attributes/${attr}"
}

declare -r chef_server=$(metadata chef-server)
declare -r org_name=$(metadata org-name)
declare -r chef_server_url="https://${chef_server}/organizations/${org_name}"
declare -r chef_server_crt=$(metadata chef-server-crt)
declare -r validator=$(metadata validator-key)
declare -r start_run_list=$(metadata runlist)
declare -r local_validator='/etc/chef/validation.pem'
declare -r startup_json='/etc/chef/startup.json'

echo '------------------------------------------------------------------------'
echo "chef server     : $chef_server"
echo "org name        : $org_name"
echo "chef server url : $chef_server_url"
echo "chef server crt : $chef_server_crt"
echo "validator       : $validator"
echo "start run list  : $start_run_list"
echo "local validator : $local_validator"
echo "startup json    : $startup_json"
echo '------------------------------------------------------------------------'

declare -r start_time=$(date +%s)
logger -t bootstrapper 'Starting bootstrap'

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
