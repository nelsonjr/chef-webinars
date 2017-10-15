# Getting Started

TODO(nelsonjr): Add documentation here

## Installation

### Installing Google Cloud Platform cookbooks

    knife supermarket install google-cloud

> Optionally you can install just the modules required by this webinar:
>
>     knife supermarket install google-gcompute
>     knife supermarket install google-gdns

### Setup the webinar cookbooks

There are 2 cookbooks used in this Webinar:

    knife supermarket install webinar1-myapp
    knife supermarket install webinar1-infra

- `webinar1-myapp` setups the application, to be uploaded to your Chef server:

      knife cookbook upload webinar1-myapp

- `webinar1-infra` setups the cloud infrastructure, to be run from the admin workstation

      chef-client -z --runlist 'recipe["webinar1-infra::myapp"]'

## Application Diagram

![Application][architecture.png]
