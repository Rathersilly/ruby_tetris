# https://gist.github.com/acook/4190379
require 'io/console'
require 'io/wait'

# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  #there's a difference here.  with raw! it clears buffer
  #and waits.
  #with system("stty raw -echo")... it makes ready true and prints out everything in buffer - but flush doesnt work
    #system("stty raw -echo") # turn raw input on
  STDIN.echo = false
  STDIN.raw!
  print "ready? "
  p STDIN.ready?
  p $stdin.ready?
  # this blocks!
  input = STDIN.read_nonblock(1)
  #input = STDIN.getc.chr #if STDIN.ready?
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
    #system "stty -raw echo" # turn raw input off
  STDIN.echo = true
  STDIN.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def show_single_key
  c = read_char

  case c
  when " "
    puts "SPACE"
  when "\t"
    puts "TAB"
  when "\r"
    puts "RETURN"
  when "\n"
    puts "LINE FEED"
  when "\e"
    puts "ESCAPE"
  when "\e[A"
    puts "UP ARROW"
  when "\e[B"
    puts "DOWN ARROW"
  when "\e[C"
    puts "RIGHT ARROW"
  when "\e[D"
    puts "LEFT ARROW"
  when "\177"
    puts "BACKSPACE"
  when "\004"
    puts "DELETE"
  when "\e[3~"
    puts "ALTERNATE DELETE"
  when "\u0003"
    puts "CONTROL-C"
    exit 0
  when /^.$/
    puts "SINGLE CHAR HIT: #{c.inspect}"
  when nil 

  else
    puts "SOMETHING ELSE: #{c.inspect}"
  end
end

begin
show_single_key
sleep 1
puts "tick"
end while(true)

