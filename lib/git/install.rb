require 'git'
require 'git/install/base'

module Git
  # The main Install driver
  class Install
    # The default install path for Unix systems
    UNIX_BIN = "/usr/local/bin/"
    # The environment variable to set install path
    INSTALL_PATH = "GIT_INSTALL_PATH"

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

    def self.download(url)
      base = self::Base.new
      base.download(url, self.repo_path)
    end
  end
end
