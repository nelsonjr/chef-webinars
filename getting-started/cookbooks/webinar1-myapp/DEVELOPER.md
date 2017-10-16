# Developer setup

If you would like to converge this locally, the easiest way
to do this is the following.

- Install the chefdk:
```shell
curl -L https://chef.io/chef/install.sh | sudo bash -s -- -P chefdk
```
- Install [Vagrant][vagrant]
- Install [Virtualbox][virtualbox]
- Go into the directory, run the following:
```shell
eval "$(chef shell-init SHELL_NAME)" # SHELL_NAME is sh, bash, zsh
kitchen list
```
- You should see something like the following, if not something is broken
and you should debug test-kitchen, start at the main site [here][tk].
```shell
Instance           Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-centos-72  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
```
- After this, you can run the following to test the cookbook
```shell
kitchen test
```
- Open up http://localhost:8080 to see the site that is created.


[tk]: http://kitchen.ci
[vagrant]: https://www.vagrantup.com/
[virtualbox]: https://www.virtualbox.org/wiki/Downloads
