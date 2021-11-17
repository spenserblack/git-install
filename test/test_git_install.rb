require 'helper'

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
    it 'should call base.download' do
      url = 'https://example.com/repo.git'
      mock = MiniTest::Mock.new
      mock.expect :download, nil, [url, '/data']

      Git::Install::Base.stub :new, mock do
        Git::Install.stub :repo_path, '/data' do
          Git::Install.download(url)
        end
      end

      mock.verify
    end
  end
end
