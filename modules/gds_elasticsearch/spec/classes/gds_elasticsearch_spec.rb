require_relative '../../../../spec_helper'

describe 'gds_elasticsearch', :type => :class do
  let(:facts) {{
    :fqdn => 'test.example.com',
    :lsbdistid => 'ubuntu',
    :operatingsystem => 'Ubuntu',
    :kernel => 'Linux',
    :osfamily => 'Debian',
  }}

  describe '#version' do

    context "when not set" do
      it { expect { should }.to raise_error(Puppet::Error, /Must pass version/) }
    end

    context "when set to 'present'" do
      let(:params) {{
        :version => 'present',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /must be in the form x\.y\.z/) }
    end
  end

  describe 'repo management' do
    let(:params) {{
      :version => '1.2.3',
    }}

    it { should contain_class('gds_elasticsearch::repo').with_repo_version('1.2') }

    it "should handle the repo for 0.90.x" do
      params[:version] = '0.90.3'
      should contain_class('gds_elasticsearch::repo').with_repo_version('0.90')
    end

    it "should handle the repo for 1.4.x" do
      params[:version] = '1.4.2'
      should contain_class('gds_elasticsearch::repo').with_repo_version('1.4')
    end

    it { should contain_class('elasticsearch').with_manage_repo(false) }
  end

  describe "enabling dynamic scripting" do
    let(:params) {{}}

    it "should not be added to 0.90" do
      params[:version] = '0.90.3'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should not be added for 1.4.2" do
      params[:version] = '1.4.2'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]).not_to have_key('script.groovy.sandbox.enabled')
    end

    it "should be added for 1.4.3" do
      params[:version] = '1.4.3'

      instance = subject.resource('elasticsearch::instance', facts[:fqdn])
      expect(instance[:config]['script.groovy.sandbox.enabled']).to eq(true)
    end
  end
end
