#
# Cookbook Name:: flower
# Attribute:: default
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

default['flower']['user'] = 'flower'
default['flower']['group'] = 'flower'
default['flower']['version'] = '0.7.3'

default['flower']['virtualenv'] = '/opt/flower'

default['flower']['binary'] = "#{node['flower']['virtualenv']}/bin/flower"
default['flower']['conf'] = "#{node['flower']['virtualenv']}/flowerconfig.py"

default['flower']['broker'] = nil
default['flower']['config'] = {}
