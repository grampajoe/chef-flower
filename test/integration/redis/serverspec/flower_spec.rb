require 'serverspec'

describe file('/opt/flower/flowerconfig.py') do
  its(:content) { should match %r{BROKER_URL = 'redis://localhost:6379/0'} }
end

describe file('/opt/flower/bin/flower') do
  it { should be_owned_by 'flower' }
  it { should be_executable }
end

describe service('flower') do
  it { should be_running }
end

describe port(9001) do
  it { should be_listening }
end
