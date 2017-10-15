name 'myapp'
maintainer 'Nelson Araujo'
maintainer_email 'nelsona@google.com'
license 'Apache-2.0'
description 'Installs/Configures sample application for Chef Webinar'
long_description 'Installs/Configures sample application for Chef Webinar'
version '0.1.5'
chef_version '>= 12.1' if respond_to?(:chef_version)
depends 'apache2'
issues_url 'https://github.com/nelsonjr/chef-webinars/issues'
source_url 'https://github.com/nelsonjr/chef-webinars'
