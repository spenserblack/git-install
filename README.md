# `git install`

[![CI](https://github.com/spenserblack/git-install/actions/workflows/ci.yml/badge.svg)](https://github.com/spenserblack/git-install/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/spenserblack/git-install/branch/master/graph/badge.svg?token=9sQ9rJlsZL)](https://codecov.io/gh/spenserblack/git-install)

A custom git subcommand to install custom git subcommands

## Installation

```bash
# After cloning this repo

gem build -o git-install.gem

# This is to prevent the executable from installing to a place not in the PATH,
# which git would then be unable to discover as a subcommand
gem install --no-user-install git-install.gem
```

## Usage

Pass the clone URL to `git install` to install the subcommand.

```shell
git install https://repo-host.example.com/user/repo.git
```

By default this will attempt to install to `/usr/local/bin/`,
which will likely require sudo. To install to a different location,
set the environment variable `GIT_INSTALL_PATH` (make sure that path
is also on `PATH`!).

## How it Works

`git-install` will perform a shallow clone of the repository.
It will then look for a file with the same name as the repository,
and make a link of that file. [git-release] is an example of how
an installable repository could look.

However, this only works when the subcommand is tracked in the
repository. What if the subcommand needs to be built with `make`,
or downloaded from another URL (like GitHub release assets)?

## Planned Features

- [ ] Support a config file (potentially `.git-config.yaml`) that
  would allow setting custom build instructions and/or download URLs
- [ ] Support upgrading installed subcommands
  - [ ] `git install upgrade` to upgrade all
  - [ ] `git install upgrade git-example-subcommand` to upgrade specific one
  - [ ] `git install self upgrade` to upgrade self

[git-release]: https://github.com/spenserblack/git-release
