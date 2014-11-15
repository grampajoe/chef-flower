require 'spec_helper'

describe 'flower::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should run' do
    expect(chef_run).to be
  end

  it 'should create the flower group' do
    expect(chef_run).to create_group('flower')
  end

  it 'should create the flower user' do
    expect(chef_run).to create_user('flower').with(
      gid: 'flower',
      system: true,
    )
  end

  it 'should include the python::default recipe' do
    expect(chef_run).to include_recipe('python::default')
  end

  it 'should create a virtualenv at /opt/flower' do
    expect(chef_run).to create_python_virtualenv('/opt/flower').with(
      owner: 'flower',
      group: 'flower',
    )
  end

  it 'should install flower' do
    expect(chef_run).to install_python_pip('flower').with(
      virtualenv: '/opt/flower',
    )
  end
end
