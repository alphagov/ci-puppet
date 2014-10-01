# == Class: ci_environment::jenkins_job_support::rabbitmq
# Sets up rabbitmq user, vhost and exchange.
class ci_environment::jenkins_job_support::rabbitmq {
  class {'::gds_rabbitmq': }

  rabbitmq_user {
    'content_store':
      password => 'content_store';
    'email_alert_service_test':
      password => 'email_alert_service_test';
    'govuk_seed_crawler':
      password => 'govuk_seed_crawler';
    'govuk_crawler_worker':
      password => 'govuk_crawler_worker',
      tags     => ['monitoring'];
  }

  rabbitmq_user_permissions {
    'content_store@/':
      configure_permission => '^amq\.gen.*$',
      read_permission      => '^(amq\.gen.*|published_documents_test)$',
      write_permission     => '^(amq\.gen.*|published_documents_test)$';
    'email_alert_service_test@/':
      configure_permission => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue)$',
      read_permission      => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue)$',
      write_permission     => '^(amq\.gen.*|email_alert_service_published_documents_test_exchange|email_alert_service_published_documents_test_queue)$';
    'govuk_seed_crawler@/':
      configure_permission => '^govuk_seed_crawler.*',
      read_permission      => '^govuk_seed_crawler.*',
      write_permission     => '^govuk_seed_crawler.*';
    'govuk_crawler_worker@/':
      configure_permission => '^govuk_crawler_worker.*',
      read_permission      => '^govuk_crawler_worker.*',
      write_permission     => '^govuk_crawler_worker.*';
  }

  gds_rabbitmq::exchange {
    'published_documents_test@/':
      ensure   => present,
      type     => 'topic';
  }

  gds_rabbitmq::exchange {
    'email_alert_service_published_documents_test_exchange@/':
      ensure   => present,
      type     => 'topic';
  }
}
