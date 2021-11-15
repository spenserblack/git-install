require 'git/install'
require 'git/install/base'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/spec'

INSTALL_PATH = "GIT_INSTALL_PATH"

describe 'Git::Install' do
  describe 'path' do
    it 'should get the default install path' do
      old_env = ENV[INSTALL_PATH]
      ENV[INSTALL_PATH] = nil
      assert_equal "/usr/local/bin/", Git::Install.path
      ENV[INSTALL_PATH] = old_env
    end

    it 'should get the overridden path' do
      old_env = ENV[INSTALL_PATH]
      ENV[INSTALL_PATH] = "~/bin/"
      assert_equal "~/bin/", Git::Install::path
      ENV[INSTALL_PATH] = old_env
    end
  end

  describe 'repo_path' do
    it 'should get the Linux clone path' do
      old_home = ENV['HOME']
      ENV['HOME'] = '/home/foo'
      expect = '/home/foo/.local/share/git-install'
      assert_equal expect, Git::Install.repo_path
      ENV['HOME'] = old_home
    end
  end

  describe 'download' do
    class FakeBase
      def initialize(name)
        @name = name
      end
      class FakeDir
        def initialize(dir)
          @dir = dir
        end
        def to_s
          "/data/#{@dir}"
        end
      end

      def dir
        FakeDir.new(@name)
      end
    end

    it 'should call Git.clone' do
      url = "https://example.com/whatever/repo.git"
      mock = MiniTest::Mock.new
      mock.expect :clone, FakeBase.new('repo'), [url, 'repo', { path: "/data", depth: 1 }]
      install = Git::Install::Base.new mock

      path = install.download(url, "/data")
      assert_equal "/data/repo", path
      mock.verify
    end
  end
end
