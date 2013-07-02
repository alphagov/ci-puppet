# Use hiera as a lightweight ENC.
node default {
  $machine_role = regsubst($::clientcert, '^(.*)-\d\..*$', '\1')
  hiera_include('classes')
}
