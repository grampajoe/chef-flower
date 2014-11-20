name             'flower'
maintainer       'Joe Friedl'
maintainer_email 'joe@joefriedl.net'
license          'Apache 2.0'
description      'Installs/Configures flower'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.4'

recipe 'flower', 'Installs and runs the Flower monitoring service.'

depends 'python'

supports 'centos', '= 6.5'
supports 'ubuntu', '= 14.04'
