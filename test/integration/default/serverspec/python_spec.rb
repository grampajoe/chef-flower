require 'serverspec'

describe file('/opt/flower/bin/python') do
  it { should be_owned_by 'flower' }
  it { should be_executable }
end

describe command('/opt/flower/bin/python --version') do
  its(:stdout) { should match /Python 2.[67]/ }
end
