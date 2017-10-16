name 'webinar1-myapp'

maintainer 'Nelson Araujo'
maintainer_email 'nelsona@google.com'

license 'Apache-2.0'
description 'Installs/Configures sample application for Chef Webinar #1'
long_description 'Installs/Configures sample application for Chef Webinar #1'
version '0.1.0'

chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'apache2', '>= 5.0.0'
depends 'ohai', '>= 5.2.0'

issues_url 'https://github.com/nelsonjr/chef-webinars/issues'
source_url 'https://github.com/nelsonjr/chef-webinars'

supports 'centos', '>= 7.0.0'
