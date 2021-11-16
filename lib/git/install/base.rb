require 'git'

module Git
  class Install
    # Base functionality for Git::Install
    class Base
      # Regex for getting repo path name from URL
      URL_REGEX = /\/(?<name>\w+)\.git/

      # Initializes the installer
      #
      # For typical usage opts can be ignored, as they are mainly used for
      # testing with mocks.
      def initialize(file: File, git: Git)
        @file = file
        @git = git
      end

      # Downloads (clones) a repository to the data directory
      #
      # Returns a path to the Git directory
      def download(url, repo_path)
        m = self.class::URL_REGEX.match(url)
        raise "Cannot match #{url} to get repo name" if m.nil?
        git = @git.clone(url, m[:name], path: repo_path, depth: 1)
        git.dir.to_s
      end

      # Creates a link to the cloned extension
      def link(source, dest)
        absolute_source = @file.absolute_path(source)
        raise "#{source} is not a file" unless @file.file? absolute_source
        @file.symlink(absolute_source, dest)
      end
    end
  end
end
