require 'spec_helper'
describe 'heka' do

  context 'On RedHat 7' do
      context 'with defaults for all parameters' do
        it { should contain_class('heka') }
      end
  end
  context 'On RedHat 6' do
      let(:facts) {{
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '6'
      }}
      context 'with defaults for all parameters' do
        it { should contain_class('heka') }
      end
  end
  context 'On CentOS 7' do
      let(:facts) {{
        :operatingsystem => 'CentOS',
        :operatingsystemmajrelease => '7'
      }}
      context 'with defaults for all parameters' do
        it { should contain_class('heka') }
      end
  end
  context 'On Ubuntu 14.04' do
      let(:facts) {{
        :operatingsystem => 'Ubuntu',
        :operatingsystemmajrelease => '14.04'
      }}
      context 'with defaults for all parameters' do
        it { should contain_class('heka') }
      end
  end
  context 'On Debian 8' do
      let(:facts) {{
        :operatingsystem => 'Debian',
        :operatingsystemmajrelease => '8'
      }}
      context 'with defaults for all parameters' do
        it { should contain_class('heka') }
      end
  end
end
