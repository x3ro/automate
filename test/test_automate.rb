require 'helper'

class TestAutomate < MiniTest::Test

  def test_single_element_chain
    c = Automate::Chain.which("Has a single element") do
      go "Set some variable" do
        pass :foo, 42
      end
    end
    assert_equal({:foo => 42}, c.run)
  end


  def test_multiple_element_chain
    c = Automate::Chain.which("Has multiple elements") do
      go "Link #1" do
        pass :out, [1]
      end

      go "Link #2" do
        _out.push(2)
        pass :out, _out
      end

      go "Link #3" do
        _out.push(3)
        pass :out, _out
      end
    end

    result = c.run({:in => 42})
    assert_equal([1,2,3], result[:out])
    assert_equal(42, result[:in])
  end


  def test_command_error
    c = Automate::Chain.which("Has an error") do
      go "Fail" do
        run "this_doesnt_even_exist___"
      end
    end

    assert_equal false, c.run
  end


  def test_unmet_demand_error
    c = Automate::Chain.which("Has an error") do
      go "Fail" do
        demand :not_given
      end
    end

    assert_equal false, c.run
  end


  def test_met_demand
    c = Automate::Chain.which("Met demand") do
      go "Pass arg" do
        demand :input
        pass :output, _input + 1
      end

      go "Check args" do
        demand :output
      end
    end

    result = c.run({:input => 42})
    assert_equal 42, result[:input]
    assert_equal 43, result[:output]
  end


  def test_method_missing_in_chain_link
    assert_raises(NameError) do
      c = Automate::Chain.which("checks method missing") do
        go "Raise name error" do
          wobblewobble
        end
      end
      c.run
    end
  end


  def test_run_successful_command
    c = Automate::Chain.which("Run shell command") do
      go "run the command" do
        demand :input
        pass :output, run("echo -n #{_input}#{_input}", false)
      end
    end

    result = c.run({:input => 42})
    assert_equal "4242", result[:output]
  end


  def test_access_variables_just_passed
    c = Automate::Chain.which("Run shell command") do
      go "run the command" do
        pass :output, 42
        pass :output, (_output + 1)
      end
    end

    result = c.run
    assert_equal 43, result[:output]
  end


  def test_manually_abort_chain_with_error
    proc = lambda { error "test" }
    assert_raises(Automate::ChainLinkFailedError) do
      Automate::ChainLink.invoke(proc, [])
    end
  end


  def test_defer_invocation
    c = Automate::Chain.which("Has a single element + defer") do
      go "Set some variable" do
        pass :foo, 42
      end

      defer "Alter the variable" do
        pass :foo, 24
      end
    end
    assert_equal({:foo => 24}, c.run)
  end


  def test_defer_invocation_order
    c = Automate::Chain.which("Test chain") do
      go "Set some variable" do
        pass :foo, 42
      end

      defer "Change that variable, this should run last" do
        pass :foo, 1000
      end

      go "This sets the variable too" do
        pass :foo, 24
      end

      defer "This should have no effect on foo's return" do
        pass :foo, 9999
      end
    end
    assert_equal({:foo => 1000}, c.run)
  end


  def test_failing_defer_command
    c = Automate::Chain.which("Has an error") do
      go "This works" do
        run "echo -n 'hi'"
      end

      defer "But this doesn't" do
        run "this_doesnt_even_exist___"
      end
    end

    assert_equal false, c.run
  end

end
