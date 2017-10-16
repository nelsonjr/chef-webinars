# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/opt/myapp/index.php') do
  it { should exist }
  it { should_not be_symlink }
end

describe port(8080) do
  it { should_not be_listening }
end

describe port(80) do
  it { should be_listening }
end
