# ci-puppet
This is a repo cloned from [puppet-skeleton](https://github.com/alphagov/puppet-skeleton)

##To set up a CI environment 

you need to do the following

initial set up
- once cloned. 
 - librarian-puppet install
 - bundle exec rake

##What we have built

###Setting up machines 
Once provisioned (see https://github.gds/pages/gds/opsmanual/infrastructure/howto/kickstart-development-environments.html)

1) run bootstrap script - https://github.com/alphagov/ci-puppet 
 - run once per machine
 - sets up apt get sources and does update
 - installs ruby 1.9.3
 - set up basic users to manage
 - tell machines their names: hostname, dns  & etc hosts

2) puppet run via fabric - https://github.gds/gds/ci-deployment
 - this packages up puppet and puppet code and runs on all the boxes
 - you may need to edit the fabric code to ensure it runs on the correct ip ranges
 - fabric also deployed the ssl certs that are needed in prod

3) Manual steps 
- need to edit jenkins settings.  - On Jenkins server Manage Jenkins -> Configure System
 - ensure that the jenkins url is correct
 - Be sure to press save even  if you didn’t change anything 

###Machine Maintenance

####Rolling out changes 
https://github.gds/gds/ci-deployment is used to roll out changes that have been made to https://github.com/alphagov/ci-puppet 

####Testing changes
the vagrant set up in https://github.com/alphagov/ci-puppet tries to match the bootstrap/fabric process, and then runs puppet. It gives you an environment to test before pushing and deploying changes to prod 

Running Vagrant up/provision will run the bootstrap scripts and then puppet to match the production process
