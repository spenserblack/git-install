require 'git'

module Git
  # The main Install driver
  class Install
    @@file = File
    @@git = Git

    # The default install path for Unix systems
    UNIX_BIN = "/usr/local/bin/"
    # The environment variable to set install path
    INSTALL_PATH = "GIT_INSTALL_PATH"

    # Regex for getting repo path name from URL
    URL_REGEX = /\/(?<name>[\w\-\.]+)\.git/
    # Gets the path to install the git subcommand to
    def self.path
      install_path = ENV[self::INSTALL_PATH]
      install_path = self::UNIX_BIN if install_path.nil? || install_path.empty?
      install_path
    end

    # Gets the path where the subcommand repositories should be
    def self.repo_path
      @@file.join ENV['HOME'], '.local', 'share', 'git-install'
    end

    # Downloads (clones) a repository to the data directory
    #
    # Returns a path to the Git directory
    #
    # repo_path is an optional path where the repo should be cloned to.
    # Defaults to Install.repo_path
    def self.download(url, repo_path: nil)
      path = repo_path || self.repo_path
      m = self::URL_REGEX.match(url)
      raise "Cannot match #{url} to get repo name" if m.nil?
      git = @@git.clone(url, m[:name], path: path, depth: 1)
      git.dir.to_s
    end

    # Creates a link to the cloned extension
    def self.link(source, dest)
      absolute_source = @@file.absolute_path(source)
      raise "#{source} is not a file" unless @@file.file? absolute_source
      @@file.symlink(absolute_source, dest)
    end

    def self.install(url)
      dir = self.download(url)
      subcommand = @@file.basename(dir)
      source = @@file.join(dir, subcommand)
      dest = @@file.join(self.path, subcommand)
      self.link(source, dest)
    end

    private

    def self.mock(sym, mock)
      full_sym = :"@@#{sym}"
      old_value = self.class_variable_get(full_sym)
      self.class_variable_set(full_sym, mock)
      yield
    ensure
      self.class_variable_set(full_sym, old_value)
    end
  end
end
