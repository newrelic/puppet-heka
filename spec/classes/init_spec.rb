require 'spec_helper'
describe 'heka' do

  context 'with defaults for all parameters' do
    it { should contain_class('heka') }
  end
end
