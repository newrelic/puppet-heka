require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|

  # Set up any facts that should exist for all tests
  c.default_facts = {
    :operatingsystem => 'RedHat',
    :kernel          => 'Linux',
    :operatingsystemmajrelease => '7'
  }
end
