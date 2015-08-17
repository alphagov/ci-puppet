require_relative '../../../spec_helper'

describe 'ci_environment::jenkins_slave', :type => :class do
  let(:facts) {{
    :concat_basedir => '/tmp',
    :fqdn => 'test.example.com',
    :lsbdistid => 'Ubuntu',
    :lsbdistcodename => 'trusty',
    :operatingsystem => 'Ubuntu',
    :operatingsystemrelease => '14.04',
    :osfamily => 'Debian',
    :kernel => 'Linux',
  }}
  let(:hiera_data) {{
    'ci_environment::jenkins_user::rubygems_api_key' => 'a_rubygems_key',
    'ci_environment::jenkins_user::gemfury_api_key' => 'a_gemfury_key',
    'ci_environment::jenkins_user::pypi_username' => 'pp-developers',
    'ci_environment::jenkins_user::pypi_test_password' => '',
    'ci_environment::jenkins_user::pypi_live_password' => '',
    'ci_environment::jenkins_user::npm_auth' => 'an_auth_token',
    'ci_environment::jenkins_user::npm_email' => 'me@example.com',
    'gds_elasticsearch::version' => '1.4.4',
  }}

  describe "setting jenkins labels" do
    let(:params) {{
      "jenkins_home" => "/tmp",
    }}

    it "sets includes the distribution label by default" do
      expect(subject).to contain_class("jenkins::slave").
        with_labels("'ubuntu-trusty'")
    end

    it "sets adds the given labels to the distribution label" do
      params["labels"] = ["foo", "bar"]
      expect(subject).to contain_class("jenkins::slave").
        with_labels("'foo bar ubuntu-trusty'")
    end

    it "errors if not given an array" do
      params["labels"] = "foo"
      expect {subject}.to raise_error(Puppet::Error, /is not an Array/)
    end
  end
end
