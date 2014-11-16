require 'serverspec'

describe file('/opt/flower/bin/flower') do
  it { should be_owned_by 'flower' }
  it { should be_executable }
end

describe service('flower') do
  it { should be_running }
end

describe port(5555) do
  it { should be_listening }
end
