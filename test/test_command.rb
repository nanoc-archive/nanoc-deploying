# encoding: utf-8

class Nanoc::Deploying::CommandTest < Minitest::Test

  include TestHelper

  def test_deploy
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    kind: rsync\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    Nanoc::CLI.run %w( deploy -t public )

    assert File.directory?('mydestination')
    assert File.file?('mydestination/blah.html')
  end

  def test_deploy_with_dry_run
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    kind: rsync\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    Nanoc::CLI.run %w( deploy -t public -n )

    refute File.directory?('mydestination')
    refute File.file?('mydestination/blah.html')
  end

  def test_deploy_with_list_without_config
    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    ios = capturing_stdio do
      Nanoc::CLI.run %w( deploy -L )
    end

    assert ios[:stdout].include?('No deployment configurations.')

    refute File.directory?('mydestination')
    refute File.file?('mydestination/blah.html')
  end

  def test_deploy_with_list
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    kind: rsync\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    ios = capturing_stdio do
      Nanoc::CLI.run %w( deploy -L )
    end

    assert ios[:stdout].include?('Available deployment configurations:')

    refute File.directory?('mydestination')
    refute File.file?('mydestination/blah.html')
  end

  def test_deploy_with_list_deployers
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    kind: rsync\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    ios = capturing_stdio do
      Nanoc::CLI.run %w( deploy -D )
    end

    assert ios[:stdout].include?('Available deployers:')

    refute File.directory?('mydestination')
    refute File.file?('mydestination/blah.html')
  end

  def test_deploy_without_kind
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    ios = capturing_stdio do
      Nanoc::CLI.run %w( deploy -t public )
    end

    assert ios[:stderr].include?('Warning: The specified deploy target does not have a kind attribute. Assuming rsync.')

    assert File.directory?('mydestination')
    assert File.file?('mydestination/blah.html')
  end

  def test_deploy_without_target_without_default
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  public:\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

     capturing_stdio do
      err = assert_raises Nanoc::Errors::GenericTrivial do
        Nanoc::CLI.run %w( deploy )
      end
      assert_equal 'The site has no deployment configuration for default.', err.message
    end
  end

  def test_deploy_without_target_with_default
    File.open('nanoc.yaml', 'w') do |io|
      io.write "deploy:\n"
      io.write "  default:\n"
      io.write "    dst: mydestination"
    end

    FileUtils.mkdir_p('build')
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }

    capturing_stdio do
      Nanoc::CLI.run %w( deploy )
    end

    assert File.directory?('mydestination')
    assert File.file?('mydestination/blah.html')
  end

end
