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
      Helper.set_env(INSTALL_PATH, nil) do
        assert_equal "/usr/local/bin/", Git::Install.path
      end
    end

    it 'should get the overridden path' do
      Helper.set_env(INSTALL_PATH, "~/bin/") do
        assert_equal "~/bin/", Git::Install::path
      end
    end
  end

  describe 'repo_path' do
    it 'should get the Linux clone path' do
      Helper.set_env('HOME', '/home/foo') do
        expect = '/home/foo/.local/share/git-install'
        assert_equal expect, Git::Install.repo_path
      end
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

  describe 'install' do
    it 'should clone the repo and link the subcommand' do
      url = 'https://example.com/repo.git'
      mock = MiniTest::Mock.new

      Git::Install.stub :repo_path, '/data' do
        Git::Install.stub :path, '/bin' do
          mock.expect :download, '/data/repo', [url, '/data']
          mock.expect :link, 0, ['/data/repo/repo', '/bin/repo']

          Git::Install::Base.stub :new, mock do
            Git::Install.install(url)
          end
        end
      end

      mock.verify
    end
  end
end
