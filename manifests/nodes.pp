# Use hiera as a lightweight ENC.
$machine_role = regsubst($::clientcert, '^(.*)-\d\..*$', '\1')
node default {
  hiera_include('classes')
}
