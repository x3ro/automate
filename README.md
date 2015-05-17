# automate

Automate is a Gem which intends to make writing shell-level automations easier by providing functionality such as:

1. Shell command error handling
1. Displaying all executed shell commands
1. Nicely formatted output
1. Makes it easy to write self-documenting, re-usable automations

These functionalities will improve as "automate" is being used, so if you see something missing or broken, just open an issue or a pull request.



## Examples

Some simple examples can be found in the `examples/` directory.



## Usage

To begin with, `Automate::Chain.which("Description of command chain")` creates a new command chain, which is defined by the block passed to it.

Inside said block, "chain links" are defined using the `go` method. Each chain link should consist of an action which can be described in a few words, thus making the entire chain a series of small operations:

    # good
    go "Clone the git repository"

    # bad
    go "Download, compile and install the linux kernel"

The chain link block defines its behavior, and the following methods are available within (and should be used in this order):

  * `demand :parameter1, :parameter2` - Demand one or more parameters from the previous chain link (or if there is none, from the initial run command).

  * `pass :parameter, <value>` - Pass a parameter to the next chain link.

  * `error <msg>` - Abort the chain with the specified error message.

  * `run "some shell command"` - Invokes a shell command, returning its result (including everything written to stderr! If you don't want to capture stderr, pass "false" as `run's` second parameter)

One can also create "deferred" chain links. These are executed (in reverse order) as soon as all regular commands have been executed, but also if any of them fails:

    go "Create temporary file" do
      demand :tmpfile

      defer "Delete temporary file" do
        run "rm #{_tmpfile}"
      end

      run "touch #{_tmpfile}"
    end


### Running a command chain

After creation, a chain can be run like so:

    c = Automate::Chain.which("...") do
      [...]
    end

    result = c.run({:param1 => 123, :param2 => "foobar"})

The result will be a hash containing all parameters passed to the initial chain or passed by any of the chain links, or `false` in case of an error in the chain.



## Other features

* You can step through all chain links by setting the `AUTOMATE_STEP` environment variable



## Caveats

* `defer` blocks MUST be defined before any command that might fail. This is a result of the current implementation of `automate`, and might be improved in a future version. Until then, the way is to put any `defer` block right at the start of a command, after any `demand` invocations.



## Feature ideas

* "Literate automate", e.g. generating a automate-based ruby script from a markdown (or similar) file to properly self-documenting scripts.

* make it possible to write "plugins" that provide pre-defined commands, e.g. "create_file" could automatically run "touch file", check if the file has actually been crated and create a defer for "rm file".

* `run` should not return `false` on error. Perhaps a `:chain_error` element in the hash should be set or something.



## Boring legal stuff

See LICENSE.txt
