# encoding: utf-8

require 'bundler'
Bundler.setup

# Setup code coverage
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
]
SimpleCov.start

require 'minitest'
require 'minitest/autorun'
require 'nanoc-core'
require 'nanoc-cli'
require 'nanoc-deploying'

module TestHelper

  def site_here
    Nanoc::SiteLoader.new.load
  end

  def setup
    helper_setup
  end

  def teardown
    helper_teardown
  end

  def helper_setup
    Nanoc::CLI::ErrorHandler.disable

    @_orig_wd = Dir.getwd

    FileUtils.mkdir_p('_site')
    FileUtils.cd('_site')

    File.write('nanoc.yaml', '{}')
    FileUtils.mkdir_p('content')
    FileUtils.mkdir_p('layouts')
    FileUtils.mkdir_p('lib')
    FileUtils.mkdir_p('build')
    File.write('Rules', 'compile "/**/*" do ; write item.identifier ; end ; layout "/**/*", :erb')
  end

  def helper_teardown
    Nanoc::CLI::ErrorHandler.enable

    FileUtils.cd(@_orig_wd)
    FileUtils.rm_rf('_site')
  end

  def capturing_stdio(&block)
    # Store
    orig_stdout = $stdout
    orig_stderr = $stderr

    # Run
    $stdout = StringIO.new
    $stderr = StringIO.new
    yield
    { :stdout => $stdout.string, :stderr => $stderr.string }
  ensure
    # Restore
    $stdout = orig_stdout
    $stderr = orig_stderr
  end

end

# Unexpected system exit is unexpected
::Minitest::Test::PASSTHROUGH_EXCEPTIONS.delete(SystemExit)
