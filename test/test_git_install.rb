require 'helper'

require 'git/install'
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
    it 'should call Git.clone' do
      url = "https://example.com/whatever/my-repo_1.com.git"
      dir_mock = MiniTest::Mock.new
      dir_mock.expect :to_s, "/data/my-repo_1.com"

      git_base_mock = MiniTest::Mock.new
      git_base_mock.expect :dir, dir_mock

      git_mock = MiniTest::Mock.new
      git_mock.expect :clone, git_base_mock, [url, 'my-repo_1.com', { path: "/data", depth: 1 }]

      Git::Install.mock_git(git_mock) do
        path = Git::Install.download(url, repo_path: "/data")
        assert_equal "/data/my-repo_1.com", path
      end
      git_mock.verify
      git_base_mock.verify
      dir_mock.verify
    end
  end

  describe 'link' do
    it 'should call File.symlink' do
      mock = MiniTest::Mock.new
      mock.expect :file?, true, ['/data/git-hello/git-hello']
      mock.expect :symlink, 0, ['/data/git-hello/git-hello', '/bin/git-hello']
      mock.expect :absolute_path, '/data/git-hello/git-hello', ['/data/../data/git-hello/git-hello']

      Git::Install.mock_file(mock) do
        Git::Install.link('/data/../data/git-hello/git-hello', '/bin/git-hello')
      end
      mock.verify
    end
  end

  describe 'install' do
    it 'should clone the repo and link the subcommand' do
      url = 'https://example.com/repo.git'
      bin_dir = "/bin"
      download_dir = "/data"

      mock = MiniTest::Mock.new
      mock.expect :basename, "repo", ["#{download_dir}/repo"]
      mock.expect(
        :join,
        "#{download_dir}/repo/repo",
        ["#{download_dir}/repo", "repo"],
      )
      mock.expect :join, "#{bin_dir}/repo", [bin_dir, "repo"]

      Git::Install.mock_file(mock) do
        Git::Install.stub :download, "#{download_dir}/repo" do
          Git::Install.stub :link, 0 do
            Git::Install.stub :path, bin_dir do
              Git::Install.install url
            end
          end
        end
      end

      mock.verify
    end
  end
end
