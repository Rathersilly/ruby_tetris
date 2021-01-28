# OMG THIS WORKS!
require 'io/console'
require 'io/wait'
  STDIN.echo = false
  # pretty sure STDIN.raw! flushes stdin
  STDIN.raw!
begin
  #print "ready 1 = "
  # p STDIN.ready?
  input = STDIN.read_nonblock(1) rescue nil
  if input == "\e" 
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
  STDIN.cooked!
  p input
  #print "ready 2 = "
  #p STDIN.ready?
  if input == "\u0003"
    puts "CONTROL-C"
    break
    #exit 0
  end
  #p input

  STDIN.iflush
  puts "tick"
  STDIN.raw!
  sleep 1
ensure
  #puts "ensure"
  #STDIN.echo = true
  #STDIN.cooked!

end while true
  STDIN.echo = true
  STDIN.cooked!
