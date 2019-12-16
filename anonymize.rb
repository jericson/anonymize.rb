#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'liquid'
require 'namey'
require 'optparse'

@generator = Namey::Generator.new
@substitutions = {
                }

options = {
  :frequency => :all
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} file ..."

  opts.on("-s", "--save FILE", "Save subsititions in a file for later use") do |s|
    options[:cachefile] = s
  end

  opts.on("-l", "--load FILE", "Load subsititions from a file") do |s|
    options[:loadfile] = s
  end
  
  opts.on("-c", "--cache FILE", "Cache substitions in a file") do |s|
    options[:loadfile] = s
  end

  opts.on("", "--common", "Use only common names") do 
    options[:frequency] = :common
  end

  opts.on("", "--rare", "Use only rare names") do 
    options[:frequency] = :rare
  end

  
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

if ARGV.length == 0
  abort(optparse.help)
end

load options[:loadfile] unless options[:loadfile].nil?

ARGV.each do | file |
  @template = Liquid::Template.parse(File.read(file),
                                    :error_mode => :strict)
  @template.render(@substitutions,
                        {strict_variables: true})
  @template.errors.each do | error |
    if variable = error.message.match(/^Liquid error: undefined variable (.*)$/)
      if full_name = variable[1].match(/^(\S+)_(\S+)$/)
        sub = @generator.name(options[:frequency], true)
        @substitutions[full_name[1]] ||= sub.split[0]
        @substitutions[full_name[2]] ||= sub.split[1]
        @substitutions[variable[1]] ||= @substitutions[full_name[1]] +
                                        ' ' +
                                        @substitutions[full_name[2]]
      else
        @substitutions[variable[1]] ||= @generator.name(options[:frequency], false)
      end
    end
  end
  
  puts @template.render(@substitutions,
                        {strict_variables: true})
  STDERR.puts @template.errors
end

unless options[:cachefile].nil?
  File.open(options[:cachefile], 'w') do |line|
    line.print "@substitutions = "
    line.puts @substitutions
  end
end
