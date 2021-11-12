require 'git/install'
require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/spec'

INSTALL_PATH = "GIT_INSTALL_PATH"

describe 'Git::Install' do
  describe 'path' do
    it 'should get the default install path' do
      old_env = ENV[INSTALL_PATH]
      ENV[INSTALL_PATH] = nil
      assert_equal Git::Install.path, "/usr/local/bin/"
      ENV[INSTALL_PATH] = old_env
    end

    it 'should get the overridden path' do
      old_env = ENV[INSTALL_PATH]
      ENV[INSTALL_PATH] = "~/bin/"
      assert_equal Git::Install::path, "~/bin/"
      ENV[INSTALL_PATH] = old_env
    end
  end

  describe 'download' do
    class FakeBase
      class FakeDir
        def to_s
          "repo"
        end
      end

      def dir
        FakeDir.new
      end
    end

    it 'should call Git.clone' do
      Git::Install.stub :path, "/data" do
        Git.stub :clone, FakeBase.new do
          assert_equal Git::Install.download("repo"), "/data/repo"
        end
      end
    end
  end
end
