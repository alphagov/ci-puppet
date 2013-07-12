# == Class: ci_environment::jenkins_slave
#
# Class to install things only on the Jenkins Slave
#
# API token in hiera needs to be updated after provisioning a new master.
#
class ci_environment::jenkins_slave {
    include java
    include jenkins::slave

    Exec['apt-get-update'] -> Class['java'] -> Class['jenkins::slave']
}
