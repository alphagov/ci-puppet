#Class to install things only on the Jenkins Slave
class ci_environment::jenkins_slave {
    include java
    include jenkins::slave

    Exec['apt-get-update'] -> Class['java'] -> Class['jenkins::slave']
}
