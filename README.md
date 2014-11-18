flower Cookbook
===============

[![Build Status](https://travis-ci.org/grampajoe/chef-flower.svg?branch=master)](https://travis-ci.org/grampajoe/chef-flower)

This cookbook installs and runs the Flower monitoring service for Celery.

Requirements
------------

### Platforms

The following platforms are directly tested with KitchenCI:

- Ubuntu 14.04
- CentOS 6.5

### Cookbooks

- python

Attributes
----------

See `attributes/default.rb` for default values.

- `node[:flower][:user]` - User running Flower.
- `node[:flower][:group]` - Group running Flower.
- `node[:flower][:version]` - Version of Flower.
- `node[:flower][:virtualenv]` - Virtualenv path.
- `node[:flower][:binary]` - Path to the Flower binary. By default, this is `bin/flower` inside the virtualenv.
- `node[:flower][:conf]` - Path to the Flower config file. By default, this is `flowerconfig.py` inside the virtualenv. If this is changed, make sure it's still on the Python path.

Flower configuration:

- `node[:flower][:broker]` - Broker URL.
- `node[:flower][:config]` - A hash of variable names to values, e.g. `'port' => '9001'`. See http://flower.readthedocs.org/en/latest/config.html#options.

Usage
-----

#### flower::default

To install and run Flower, Just include `flower` in your node's `run_list`.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write tests for your change (if applicable)
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Limitations
-----------

- Using an existing Celery app for configuration isn't currently supported.
- Flower must be in its own virtualenv. Reusing an existing virtualenv isn't recommended.
- This cookbook uses the `python` cookbook, and may be incompatible with existing Python installations.

License and Authors
-------------------

- Author: Joe Friedl (<joe@joefriedl.net>)

```text
Copyright 2014, Joe Friedl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
