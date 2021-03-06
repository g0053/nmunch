require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'pcap'
require 'ipaddr'
require 'paint'
require 'nmunch'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

def capture_stdout
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

ARP_PACKET_DATA = "\xff\xff\xff\xff\xff\xff\xde\xad\xbe\xef\xde\xad\x08\x06\x00\x01" +
                  "\x08\x00\x06\x04\x00\x01\xde\xad\xbe\xef\xde\xad\xc0\xa8\x00\x7d" +
                  "\x00\x00\x00\x00\x00\x00\xc0\xa8\x00\x42"

IP_PACKET_DATA  = "\x7b\x22\x68\x6f\x73\x74\xde\xad\xbe\xef\xde\xad\x20\x32\x36\x37" +
                  "\x35\x37\x32\x31\x31\x30\x2c\x20\x22\x76\x65\x72\x73\x69\x6f\x6e" +
                  "\x22\x3a\x20\x5b\x31\x2c\x20\x38\x5d\x2c\x20\x22\x64\x69\x73\x70" +
                  "\x6c\x61\x79\x6e\x61\x6d\x65\x22\x3a\x20\x22\x32\x36\x37\x35\x37" +
                  "\x32\x31\x31\x30\x22\x2c\x20\x22\x70\x6f\x72\x74\x22\x3a\x20\x31" +
                  "\x37\x35\x30\x30\x2c\x20\x22\x6e\x61\x6d\x65\x73\x70\x61\x63\x65" +
                  "\x73\x22\x3a\x20\x5b\x31\x34\x33\x30\x30\x33\x33\x37\x36\x2c\x20" +
                  "\x31\x31\x35\x36\x33\x34\x38\x35\x38\x2c\x20\x31\x31\x38\x39\x30" +
                  "\x36\x37\x30\x31\x5d\x7d"