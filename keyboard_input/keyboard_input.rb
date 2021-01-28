# https://stackoverflow.com/questions/174933/how-to-get-a-single-character-without-pressing-enter%EF%BC%9F
require 'io/console'


begin
  system("stty raw -echo")
  str = STDIN.getc
  p STDIN.ready?
  p str.chr
ensure
  system("stty -raw echo")
end while str != "q"
p str.chr


# or this actually works well:
str = STDIN.getch
puts str


  


