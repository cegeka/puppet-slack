#!/usr/bin/env rspec

require 'spec_helper'

describe 'slack' do
  it { should contain_class 'slack' }
end
