# ci-puppet

## Development Workflow

- Clone this repository
- Run `bundle exec librarian-puppet install` to gather the external modules
- Run `bundle exec rake` to run the tests
- Make changes to the repository
- Run `bundle exec rake` to run the tests
- Run `vagrant up` to instantiate the machines (requires Vagrant and either VirtualBox or VMWare Fusion)
- Note whether your change was successful
- Make more changes to the repository
- Run `bundle exec rake` to run the tests
- Run `vagrant provision` to apply new puppet code to the machines.
- ...
- Profit!

## Setting up a real environment on remote machines

Provision blank Ubuntu 12.04 machines, possibly running [machine-bootstrap](https://github.com/alphagov/machine-bootstrap) to add some basic security to the machines.

1. Run the bootstrap script from `tools/bootstrap` on each new machine.
   It should be run as locally on those machines as `./bootstrap machinename.domainname`
   The script:
     - sets up apt sources and runs `apt-get update`
     - installs ruby 1.9.3
     - set up basic users to manage the environment (you will need to edit this if your user is not included)
     - tell machines their names: hostname, dns  & etc hosts
2. Run puppet on the machines (for GDS, this is done with Fabric from the [ci-deployment repository](https://github.gds/gds/ci-deployment))
   - this packages up puppet and puppet code and runs on all the boxes
   - you may need to edit the fabric code to ensure it runs on the correct ip ranges
   - fabric can also deploy the ssl certs that are needed in prod
3. Manual steps
   - The manual steps are contained within the Ops Manual: https://github.gds/pages/gds/opsmanual/infrastructure/howto/configuring-ci-environment-and-machines.html
4. Rolling out changes:
   - Once you are happy that the puppet code is correct (follow _Development Workflow_ above), then
     you can apply code changes to CI by running the fabric scripts described in Section 2 above.
