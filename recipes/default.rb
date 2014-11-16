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

group 'flower'

user 'flower' do
  gid 'flower'
  system true
end

include_recipe 'python::default'

python_virtualenv '/opt/flower' do
  owner 'flower'
  group 'flower'
end

python_pip 'flower' do
  virtualenv '/opt/flower'
  user 'flower'
  group 'flower'
end

template '/etc/init/flower.conf'

service 'flower' do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
