# automate

Automate is a Gem which intends to make writing shell-level automations easier by providing functionality such as:

1. Shell command error handling
1. Displaying all executed shell commands
1. Nicely formatted output
1. Makes it easy to write self-documenting, re-usable automations

These functionalities will improve as "automate" is being used, so if you see something missing or broken, just open an issue or a pull request.



## Example

Here's a very short example which creates a file and writes a random number into it (also to be found in `examples/simple.rb`):

    c = Automate::Chain.which("Serves as an example") do

      go "Create a file in the working directory" do
        demand :filename
        run "touch #{_filename}"
      end

      go "Write a random number into the file" do
        pass :number, Random.rand(100)
        run "echo #{_number} > #{_filename}"
      end

      go "Demonstrate a failed chain link" do
        run "this_command_doesnt_even_exist #{_number}"
      end

    end



## Usage

To begin with, `Automate::Chain.which("Description of command chain")` creates a new command chain, which is defined by the block passed to it.

Inside said block, "chain links" are defined using the `go` method. Each chain link should consist of an action which can be described in a few words, thus making the entire chain a series of atomic, or close to atomic operations:

    # good
    go "Clone the git repository"

    # bad
    go "Download, compile and install the linux kernel"

The chain link block defines its behavior, and the following methods are available within:

  * `demand :parameter1, :parameter2` - Demand one or more parameters from the previous chain link (or if there is none, from the initial run command).

  * `pass :parameter, value` - Pass a parameter to the next chain link.

  * `run "some shell command"` - Invokes a shell command, returning its result (including everything written to stderr! If you don't want to capture stderr, pass "false" as `run's` second parameter)

One can also create "deferred" chain links. These are executed as soon as all regular commands have been executed, but also if any of them fails:

    go "Create temporary file" do
      demand :tmpfile

      defer "Delete temporary file" do
        run "rm #{_tmpfile}"
      end

      run "touch #{_tmpfile}"
    end



## Caveats

* `defer` blocks MUST be defined before any command that might fail. This is a result of the current implementation of `automate`, and might be improved in a future version. Until then, the way is to put any `defer` block right at the start of a command, after any `demand` invocations.



## Future features

* Stepping through the script, i.e. execute link by link (especially useful for debugging)
* Add roll back actions for a link, which are only executed if said link fails.



## Boring legal stuff

See LICENSE.txt
