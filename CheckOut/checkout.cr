#!/usr/bin/env crystal

require "crypto/md5"
require "crypto/sha1"
require "crypto/sha256"
require "crypto/sha512"
require "option_parser"
require "file_utils"

module CheckOut
  VERSION = "1.0.0"
  AUTHOR  = "Jashin L."

  class HashTool
    def initialize
      @input = ""
      @type = ""
      @file = false
    end

    def run
      parse_options
      process_hash
    end

    private def parse_options
      OptionParser.parse do |parser|
        parser.banner = "Usage: checkout [options]"

        parser.on("-t TYPE", "--type=TYPE", "Hash type (md5/sha1/sha256/sha512)") { |type| @type = type }
        parser.on("-i INPUT", "--input=INPUT", "Input string or file") { |input| @input = input }
        parser.on("-f", "--file", "Input is a file") { @file = true }
        parser.on("-h", "--help", "Show help") do
          puts parser
          exit
        end
        parser.on("-v", "--version", "Show version") do
          puts "CheckOut #{VERSION}"
          exit
        end
      end
    end

    private def process_hash
      input_data = @file ? File.read(@input) : @input

      case @type.downcase
      when "md5"
        puts Crypto::MD5.hex_digest(input_data)
      when "sha1"
        puts Crypto::SHA1.hex_digest(input_data)
      when "sha256"
        puts Crypto::SHA256.hex_digest(input_data)
      when "sha512"
        puts Crypto::SHA512.hex_digest(input_data)
      else
        puts "All hashes for input:"
        puts "MD5: #{Crypto::MD5.hex_digest(input_data)}"
        puts "SHA1: #{Crypto::SHA1.hex_digest(input_data)}"
        puts "SHA256: #{Crypto::SHA256.hex_digest(input_data)}"
        puts "SHA512: #{Crypto::SHA512.hex_digest(input_data)}"
      end
    end
  end
end

tool = CheckOut::HashTool.new
tool.run
