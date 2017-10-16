name 'webinar1-infra'

maintainer 'Nelson Araujo'
maintainer_email 'nelsona@google.com'

license 'Apache-2.0'
description 'Installs/Configures Google Cloud Platform for Chef Webinar #1'
long_description 'Installs/Configures Google Cloud Platform for Chef Webinar #1'
version '0.1.0'

chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'webinar1-myapp', '~> 0.1.0'
depends 'google-gauth', '~> 0.1.0'
depends 'google-gcompute', '~> 0.1.1'
depends 'google-gdns', '~> 0.1.0'

issues_url 'https://github.com/nelsonjr/chef-webinars/issues'
source_url 'https://github.com/nelsonjr/chef-webinars'

supports 'centos', '>= 7.0.0'
