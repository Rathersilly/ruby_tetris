# OMG THIS WORKS TOO!
require 'io/console'
require 'io/wait'
  STDIN.echo = false
  STDIN.raw!
def key_pressed #char_if_pressed
  if STDIN.ready?
    input = STDIN.read_nonblock(1) rescue nil
    if input == "\e" 
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  end
  STDIN.cooked!
  
  input

  #STDIN.iflush
end
while false #yeah lets disable this
  c = key_pressed
  puts "[#{c}]" if c
  puts "tick"
  if c == "\u0003"
    puts "CONTROL-C"
    break
  end
  STDIN.raw!
  sleep 1

end
  STDIN.echo = true
  STDIN.cooked!
