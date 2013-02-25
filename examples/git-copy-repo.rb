#!/usr/bin/env ruby

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'automate'

c = Automate::Chain.which("copies a git repository") do

  go "Clone git repository" do
    demand :source, :tmpdir
    run "git clone #{_source} #{_tmpdir}"
  end

  go "Chdir to temporary directory" do
    demand :tmpdir
    pass :old_dir, Dir.pwd
    Dir.chdir _tmpdir
  end

  go "Find out which remote branches need to be checked out" do
    branches = run "git branch -r"
    branches = branches.split("\n")
      .select { |x| !x.include? "->" }
      .select { |x| !x.include? "/master" }
      .select { |x| x.include? 'origin/' }
      .map { |x| x.strip }

    notice "Will check out these branches:", " #{branches.join(" ")}"
    pass :branches, branches
  end

  go "Check out the remote branches" do
    _branches.each do |branch|
      run "git checkout --track #{branch}"
    end
  end

  go "Add target remote to repository" do
    demand :target
    run "git remote add new #{_target}"
  end

  go "Push data to target repository" do
    run "git push --all new"
  end

  go "Push tags to target repository" do
    run "git push --tags new"
  end

  go "Delete temporary directory" do
    demand :old_dir, :tmpdir
    Dir.chdir _old_dir
    run "rm -rf #{Dir.pwd}/#{_tmpdir}"
  end

end



abort("Usage: git-copy-repo <source repo> <target repo>") if ARGV.length != 2
c.run({:source => ARGV[0], :target => ARGV[1], :tmpdir => "tmp/"})
