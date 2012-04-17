{spawn} = require 'child_process'
puts = console.log

system = (name, args) ->
  print = (buffer) -> process.stdout.write buffer.toString()
  proc = spawn name, args
  proc.stdout.on 'data', print
  proc.stderr.on 'data', print
  proc.on        'exit', (status) ->
    process.exit(1) if status != 0

compileall = (from, to, watch = false) ->
  args = ['-o', to, '-c', from]
  args.unshift '-w' if watch
  system 'coffee', args

task 'c', 'Compile and watch', ->
  compileall 'src/', 'js/', true

task 'compile', 'Compile', ->
  puts "Compiling..."
  compileall 'src/', 'js/'