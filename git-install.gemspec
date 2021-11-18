git_version = `git describe --tags --abbrev=0 --match="v*.*.*"`
# NOTE Default version if version is not in repo.
# This can happen with a shallow clone for a CI, for example.
git_version = 'v0.0.0.dev' if git_version.empty?
version = /v?(\d+\.\d+\.\d+(?:\..+)?)/.match(git_version)[1]

Gem::Specification.new do |s|
  s.name        = 'git-install'
  s.version     = version
  s.summary     = 'Install git subcommands'
  s.description = 'Install custom git subcommands from their repositories'
  s.authors     = ['Spenser Black']
  s.files       = ['lib/git/install.rb']
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/spenserblack/git-install'

  s.executables << 'git-install'
  s.executables << 'git-uninstall'

  s.add_runtime_dependency 'git', '~> 1.9'

  s.add_development_dependency 'codecov'
  s.add_development_dependency 'simplecov'
end
