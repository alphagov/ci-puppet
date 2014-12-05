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

## Provisioning a new environment or a new machine

See the [ci-deployment][] repository [README][] for instructions.

[ci-deployment]: https://github.gds/gds/ci-deployment
[README]: https://github.gds/gds/ci-deployment/blob/master/README.md
