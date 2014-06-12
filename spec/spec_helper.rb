# configure rspec conf
RSpec.configure do |c|
  c.fail_fast = false
  c.color = true
  c.tty = true
end


# configure load path
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), 'spec')

# require lib/kic
require 'kic'

# require libraries
require 'pp'
