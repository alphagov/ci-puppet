require_relative '../../../../spec_helper'

describe 'gds_elasticsearch', :type => :class do
  let(:facts) {{
    :operatingsystem => 'Ubuntu',
    :kernel => 'Linux',
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
end
