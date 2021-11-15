require 'git'

module Git
  # The main Install driver
  class Install
    # The default install path for Unix systems
    UNIX_BIN = "/usr/local/bin/"
    # The environment variable to set install path
    INSTALL_PATH = "GIT_INSTALL_PATH"
    # Regex for getting repo path name from URL
    URL_REGEX = /\/(?<name>[\w\d]+)\.git/

    # Initializes the installer
    #
    # The "git" instance can be overridden, but uses the git gem by default
    def initialize(git = Git)
      @git = git
    end

    # Gets the path to install the git subcommand to
    def self.path
      install_path = ENV[self::INSTALL_PATH]
      install_path = self::UNIX_BIN if install_path.nil? || install_path.empty?
      install_path
    end

    # Gets the path where the subcommand repositories should be
    def self.repo_path
      File.join ENV['HOME'], '.local', 'share', 'git-install'
    end

    # Downloads (clones) a repository to the data directory
    #
    # Returns a path to the Git directory
    def download(url)
      m = self.class::URL_REGEX.match(url)
      raise "Cannot match #{url} to get repo name" if m.nil?
      path = self.class.repo_path
      git = @git.clone(url, m[:name], path: path, depth: 1)
      git.dir.to_s
    end

  end
end
