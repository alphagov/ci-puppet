Transition Logs Machine
=======================

The purpose of this machine is twofold:

1. It is the place where Agencies will be dumping pre-transition logs via SFTP
2. Is it the place where we will collect our Fastly CDN logs

1) SFTP for Agencies
====================

Adding SFTP Users for Agencies
------------------------------

In order to add a new user for SFTP, it needs to be added to the
[hieradata](https://github.com/alphagov/ci-puppet/blob/master/hieradata/role.transition-logs.yaml)
and then the CI puppet config deployed. Deployment instructions are available in the `ci-deployment`
repository on GitHub Enterprise.

To create the new key for the Agency, you can can use the following command:

    ssh-keygen -t rsa -b 2048 -f agency_key -N ""

That will create a new RSA private key called `agency_key`. The new public key will be `agency_key.pub`
and this is what needs to be pasted into the new user in Puppet.

Connection Details to be supplied to the agency:

    Protocol: SFTP
    User: <the user created>
    Pass: <empty>
    Host: <the DNS name of the transition-logs machine>
    Key:  <the private key created>

Transferring files from Windows
-------------------------------

Agencies may not be using Linux tools to transfer their logs. On Windows, there are two popular applications which can be used: [WinSCP](http://winscp.net/) and [PuTTY sftp](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) - look for the psftp.exe link. If using PuTTY sftp, note that connections with PuTTY itself won't work, it must be PuTTY sftp.

Both of these programs use the same key format (PPK) and instructions for converting an OpenSSH private key are [available here](http://meinit.nl/using-your-openssh-private-key-in-putty)

2) CDN Logs
===========

