require 'spec_helper'

describe 'flower::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }
  let(:flower_config) { '/opt/flower/flowerconfig.py' }
  let(:upstart_config) { '/etc/init/flower.conf' }

  context 'installation' do
    before(:each) { chef_run.converge(described_recipe) }

    it 'should create the flower group' do
      expect(chef_run).to create_group('flower')
    end

    it 'should create the flower user' do
      expect(chef_run).to create_user('flower').with(
        gid: 'flower',
        system: true
      )
    end

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
        version: '0.7.3',
        user: 'flower',
        group: 'flower'
      )
    end
  end

  context 'the service' do
    before(:each) { chef_run.converge(described_recipe) }

    it 'should be started with Upstart' do
      expect(chef_run).to start_service('flower').with(
        provider: Chef::Provider::Service::Upstart,
        restart_command: '/sbin/stop flower; /sbin/start flower'
      )
    end

    it 'should have an upstart config file' do
      expect(chef_run).to render_file(upstart_config)
    end

    it 'should restart when the upstart config changes' do
      resource = chef_run.find_resource('template', upstart_config)

      expect(resource).to notify('service[flower]').to(:restart).delayed
    end

    it 'should respawn' do
      expect(chef_run).to render_file(upstart_config).with_content(
        'respawn'
      )
    end

    it 'should chdir to the virtualenv' do
      expect(chef_run).to render_file(upstart_config).with_content(
        'chdir /opt/flower'
      )
    end

    it 'should be configured to run' do
      expect(chef_run).to render_file(upstart_config).with_content(
        %r{exec su -c "/opt/flower/bin/flower" flower}
      )
    end
  end

  context 'with a redis broker' do
    it 'should install the redis package' do
      chef_run.node.set[:flower][:broker] = 'redis://lookitsredis:wow/amaze'
      chef_run.converge(described_recipe)

      expect(chef_run).to install_python_pip('redis').with(
        virtualenv: '/opt/flower',
        user: 'flower',
        group: 'flower'
      )
    end
  end

  context 'the config file' do
    it 'should render the config file' do
      chef_run.converge(described_recipe)

      expect(chef_run).to create_template(flower_config).with(
        owner: 'flower',
        group: 'flower'
      )
    end

    it 'should set the broker' do
      chef_run.node.set[:flower][:broker] = 'redis://broker-host:port/butt'
      chef_run.converge(described_recipe)

      expect(chef_run).to render_file(upstart_config).with_content(
        '--broker=redis://broker-host:port/butt'
      )
    end

    it 'should allow arbitrary config' do
      chef_run.node.set[:flower][:config] = {
        'hello' => 123,
        'wow' => 'amazing',
        'ALL_CAPS' => 'test'
      }
      chef_run.converge(described_recipe)

      expect(chef_run).to render_file(flower_config).with_content(
        'hello = 123'
      )
      expect(chef_run).to render_file(flower_config).with_content(
        "wow = 'amazing'"
      )
      expect(chef_run).to render_file(flower_config).with_content(
        "ALL_CAPS = 'test'"
      )
    end

    it 'should restart the service on config changes' do
      chef_run.converge(described_recipe)
      resource = chef_run.find_resource('template', flower_config)

      expect(resource).to notify('service[flower]').to(:restart).delayed
    end
  end
end
