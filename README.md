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

### Oracle Java 7 "fun"

The Oracle Java 7 installer needs to be preseeded with the oracle tarball. If
jdk-7u9-linux-x64.tar.gz is present in the `vendor` folder, the vagrant
bootstrap script will copy it into the necessary location before provisioning.

Due to Oracle's licence terms we can't commit this tarball to this (public)
repository, nor can we make it available at a download URL that we make public,
so determining where to download this tarball from is left as an exercise for
the reader.

## Provisioning a new environment or a new machine

See the [ci-deployment][] repository [README][] for instructions.

[ci-deployment]: https://github.gds/gds/ci-deployment
[README]: https://github.gds/gds/ci-deployment/blob/master/README.md
