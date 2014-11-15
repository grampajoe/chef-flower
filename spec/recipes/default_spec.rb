require 'spec_helper'

describe 'flower::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should run' do
    expect(chef_run).to be
  end
end
