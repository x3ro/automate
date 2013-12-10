require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end


require 'minitest/autorun'
require "minitest/reporters"
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'automate'


class MiniTest::Test
  def setup
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  def teardown
    $stdout = @original_stdout
  end
end


MiniTest.autorun
