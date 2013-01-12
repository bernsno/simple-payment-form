# Required to run commands in the shell
# @see http://nodejs.org/api/child_process.html
{spawn, exec} = require 'child_process'

# A basic command runner
run = (cmd, args) ->
  console.log cmd, args.join ' '
  spawn cmd, args, stdio: 'inherit'

# Set up default arguments for running our Mocha tests.
# The first argument passed to Mocha is the location of our
# test files. Meteor expects our specs to be located in the
# "tests" folder, which differs from Mocha's default test
# location (i.e. "test").
# @see http://docs.meteor.com/#structuringyourapp
# @see http://stackoverflow.com/questions/11785917/where-should-unit-tests-be-placed-in-meteor
mocha_args = [
  'tests',
  '--recursive',
  '--compilers', 'coffee:coffee-script',
  '--require', 'chai',
  '--ui', 'bdd',
  '--colors',
]

# Standard test runner with complete spec-style output
task 'test', 'runs the Mocha test suite', ->
  run 'mocha', mocha_args.concat ['--reporter', 'spec']...

# Our watchful test runner to use during development and refactoring
task 'test:watch', 'runs the Mocha test suite whenever a file on the project is changed', ->
  run 'mocha', mocha_args.concat [
    '--reporter', 'min',
    '--watch'
  ]...