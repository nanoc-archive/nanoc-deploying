# encoding: utf-8

class Nanoc::Deploying::Deployers::RsyncTest < Minitest::Test

  include TestHelper

  def test_run_without_dst
    # Create deployer
    rsync = Nanoc::Deploying::Deployers::Rsync.new(
      'build/',
      {})

    # Mock run_shell_cmd
    def rsync.run_shell_cmd(args)
      @shell_cms_args = args
    end

    # Try running
    error = assert_raises(RuntimeError) do
      rsync.run
    end

    # Check error message
    assert_equal 'No dst found in deployment configuration', error.message
  end

  def test_run_with_erroneous_dst
    # Create deployer
    rsync = Nanoc::Deploying::Deployers::Rsync.new(
      'build/',
      { :dst => 'asdf/' })

    # Mock run_shell_cmd
    def rsync.run_shell_cmd(args)
      @shell_cms_args = args
    end

    # Try running
    error = assert_raises(RuntimeError) do
      rsync.run
    end

    # Check error message
    assert_equal 'dst requires no trailing slash', error.message
  end

  def test_run_everything_okay
    # Create deployer
    rsync = Nanoc::Deploying::Deployers::Rsync.new(
      'build',
      { :dst => 'asdf' })

    # Mock run_shell_cmd
    def rsync.run_shell_cmd(args)
      @shell_cms_args = args
    end

    # Run
    rsync.run

    # Check args
    opts = Nanoc::Deploying::Deployers::Rsync::DEFAULT_OPTIONS
    assert_equal(
      [ 'rsync', opts, 'build/', 'asdf' ].flatten,
      rsync.instance_eval { @shell_cms_args }
    )
  end

  def test_run_everything_okay_dry
    # Create deployer
    rsync = Nanoc::Deploying::Deployers::Rsync.new(
      'build',
      { :dst => 'asdf' },
      :dry_run => true)

    # Mock run_shell_cmd
    def rsync.run_shell_cmd(args)
      @shell_cms_args = args
    end

    # Run
    rsync.run

    # Check args
    opts = Nanoc::Deploying::Deployers::Rsync::DEFAULT_OPTIONS
    assert_equal(
      [ 'echo', 'rsync', opts, 'build/', 'asdf' ].flatten,
      rsync.instance_eval { @shell_cms_args }
    )
  end

end
