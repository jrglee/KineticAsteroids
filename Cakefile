{exec} = require 'child_process'

task 'test', 'run all tests suites', ->
  phantom_bin = "PHANTOMJS_BIN=#{__dirname}/node_modules/phantomjs/lib/phantom/bin/phantomjs"
  testacular = "#{__dirname}/node_modules/testacular/bin/testacular"
  options = "--single-run --browsers=PhantomJS"

  exec "#{phantom_bin} #{testacular} start #{__dirname}/testacular.conf.js #{options}", (err, stdout, stderr) ->
    console.error err if err
    console.log stdout
