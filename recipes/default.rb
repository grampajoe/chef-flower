#
# Cookbook Name:: flower
# Recipe:: default
#
# Copyright 2014, Joe Friedl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

group node['flower']['group']

user node['flower']['user'] do
  gid node['flower']['group']
  system true
end

include_recipe 'python::default'

python_virtualenv node['flower']['virtualenv'] do
  owner node['flower']['user']
  group node['flower']['group']

  not_if { node['flower']['virtualenv'].nil? }
end

python_pip 'flower' do
  user node['flower']['user']
  group node['flower']['group']
  virtualenv node['flower']['virtualenv']
  version node['flower']['version']
end

python_pip 'redis' do
  user node['flower']['user']
  group node['flower']['group']
  virtualenv node['flower']['virtualenv']

  only_if do
    broker = node['flower']['broker']
    broker && broker.start_with?('redis://')
  end
end

template '/etc/init/flower.conf' do
  notifies :restart, 'service[flower]', :delayed
end

template node['flower']['conf'] do
  source 'flowerconfig.py.erb'
  owner node['flower']['user']
  group node['flower']['group']

  notifies :restart, 'service[flower]', :delayed
end

service 'flower' do
  provider Chef::Provider::Service::Upstart
  restart_command '/sbin/stop flower; /sbin/start flower'
  action [:enable, :start]
end
