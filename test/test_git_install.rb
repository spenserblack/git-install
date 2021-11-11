require 'git/install'
require 'minitest/autorun'

INSTALL_PATH = "GIT_INSTALL_PATH"

class GitInstallTest < Minitest::Test
  def test_path_no_override
    old_env = ENV[INSTALL_PATH]
    ENV[INSTALL_PATH] = nil
    assert_equal Git::Install::path, "/usr/local/bin/"
    ENV[INSTALL_PATH] = old_env
  end

  def test_path_override
    old_env = ENV[INSTALL_PATH]
    ENV[INSTALL_PATH] = "~/bin/"
    assert_equal Git::Install::path, "~/bin/"
    ENV[INSTALL_PATH] = old_env
  end
end
