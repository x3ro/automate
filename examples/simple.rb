#!/usr/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'automate'

c = Automate::Chain.which("Serves as an example") do

  go "Create a file in the working directory" do
    demand :filename
    defer "Clean up temporary file" do
      run "rm #{_filename}"
    end

    run "touch #{_filename}"
  end

  go "Write a random number into the file" do
    pass :number, Random.rand(100)
    run "echo #{_number} > #{_filename}"
  end

  go "Demonstrate a failed chain link" do
    defer "Demonstrate defer" do
      run "echo 'Look ma, defer'"
    end

    run "this_command_doesnt_even_exist #{_number}"
  end

end

abort "Usage: simple.rb <filename>" if ARGV.length != 1
c.run({:filename => ARGV[0]})
