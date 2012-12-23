r = require.config
  baseUrl: '/base/src'
  paths:
    jquery: '../lib/jquery-1.8.3.min'
    signals: '../lib/signals.min'
    kinetic: '../lib/kinetic-v4.2.0.min'
    cs: '../lib/cs'
    'coffee-script': '../lib/coffee-script'
  shim:
    kinetic:
      exports: 'Kinetic'

tests = [
  'vector'
]

# execute all test files
tests.forEach (file) ->
  r ["cs!../specs/#{file}.spec"], ->
    window.__testacular__.start()