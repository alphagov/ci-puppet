# == Class: ci_environment::jenkins_job_support::rabbitmq
# Sets up rabbitmq user, vhost and exchange.
class ci_environment::jenkins_job_support::rabbitmq {
  class {'::gds_rabbitmq': }

  rabbitmq_user {
    'content_store':
      password => 'content_store';
  }

  rabbitmq_user_permissions {
    'content_store@/':
      configure_permission => '^amq\.gen.*$',
      read_permission      => '^(amq\.gen.*|published_documents_test)$',
      write_permission     => '^(amq\.gen.*|published_documents_test)$',
  }

  gds_rabbitmq::exchange {
    'published_documents_test@/':
      ensure   => present,
      type     => 'topic';
  }
}
