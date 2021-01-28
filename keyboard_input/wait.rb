# check out Ruby stdlib docs: io/console, io/wait
require 'io/wait'
require 'io/console' # for .ioflush

def char_if_pressed
  begin
    system("stty raw -echo") # turn raw input on
    c = nil
    if $stdin.ready?
      c = $stdin.getc
      print "*"
      puts c
    end
    p $stdin.ready?
    $stdin.ioflush
    $stdin.oflush
    $stdin.iflush
    $stdin.flush

    p $stdin.ready?
    print "iosync "
    p $stdin.sync
    c.chr if c
  ensure
    system "stty -raw echo" # turn raw input off
  end
end

while true
  c = char_if_pressed
  puts "[#{c}]" #if c
  sleep 1
  # ok putting $stdin.iflush here makes no c output
  # same with $stdout.iflush

  puts "tick"
end

