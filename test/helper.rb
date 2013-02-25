require 'rubygems'


require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end


require 'minitest/unit'
require "minitest/reporters"
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new


require 'simplecov'
SimpleCov.start


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'automate'


class MiniTest::Unit::TestCase
  def setup
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  def teardown
    $stdout = @original_stdout
  end
end


MiniTest::Unit.autorun
