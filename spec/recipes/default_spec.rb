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
      system: true
    )
  end

  context 'installation' do
    it 'should include the python::default recipe' do
      expect(chef_run).to include_recipe('python::default')
    end

    it 'should create a virtualenv at /opt/flower' do
      expect(chef_run).to create_python_virtualenv('/opt/flower').with(
        owner: 'flower',
        group: 'flower'
      )
    end

    it 'should install flower' do
      expect(chef_run).to install_python_pip('flower').with(
        virtualenv: '/opt/flower',
        user: 'flower',
        group: 'flower'
      )
    end
  end

  context 'the service' do
    it 'should be started with Upstart' do
      expect(chef_run).to start_service('flower').with(
        provider: Chef::Provider::Service::Upstart
      )
    end

    it 'should have an upstart config file' do
      expect(chef_run).to render_file('/etc/init/flower.conf')
    end

    it 'should respawn' do
      expect(chef_run).to render_file('/etc/init/flower.conf').with_content(
        'respawn'
      )
    end

    it 'should be configured to run' do
      expect(chef_run).to render_file('/etc/init/flower.conf').with_content(
        /exec su -c "\/opt\/flower\/bin\/flower.*" flower/
      )
    end
  end
end
