# `git install`

A custom git subcommand to install custom git subcommands

## Usage

Pass the clone URL to `git install` to install the subcommand.

```shell
git install https://repo-host.example.com/user/repo.git
```

By default this will attempt to install to `/usr/local/bin/`,
which will likely require sudo. To install to a different location,
set the environment variable `GIT_INSTALL_PATH` (make sure that path
is also on `PATH`!).

### Upgrading Installed Extensions

```shell
# Upgrade all subcommands
git install upgrade

# Upgrade a specific subcommand
git install upgrade git-example-subcommand

# Upgrade git-install
git install self upgrade
```

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

[git-release]: https://github.com/spenserblack/git-release