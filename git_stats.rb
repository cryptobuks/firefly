#!/usr/bin/env ruby
# please add enhancements to http://gist.github.com/234560
require 'rubygems'
require 'optparse'
require 'active_support/all'

start = Time.now.to_i
STDOUT.sync = true

same = [
  ['my name','my-name']
]

# parse options
options = {}
OptionParser.new do |opts|
  opts.banner = <<BANNER
Show git stats, options are:
BANNER
  opts.on("--limit [LIMIT]", Integer, "Limit"){|x| options[:limit] = x }
  opts.on("--max-lines [SIZE]", Integer, "Max lines per commit <-> ignore large commits"){|x| options[:max_lines] = x }
end.parse!

# parse commits
pipe = open('|git log --pretty=format:"A:%an" --shortstat --no-merges') # --after=2009-12-10 --before=2008-12-10
author = "unknown"
stats = {}

count = 0
loop do
  count += 1
  break if options[:limit] and count/2 > options[:limit] # we have 2 lines per commit

  line = pipe.readline rescue break
  if line =~ /^A\:(.*?)$/
    author = $1.strip
    found = same.detect{|a| a.include?(author)}
    author = found.first if found
    next
  end
  if line =~ /files changed, (\d+) insertions\(\+\), (\d+) deletions/
    add = $1.to_i
    remove = $2.to_i
    if options[:max_lines] and add + remove > options[:max_lines]
      print 'x'
    else
      stats[author] ||= Hash.new(0)
      stats[author]['+'] += add
      stats[author]['-'] += remove
      print '.'
    end
  end
end

puts "\nGit scores (in LOC):"
puts stats.sort_by{|a,d| -d['+'] }.map{|author, data| "#{author.ljust(20)}:  +#{data['+'].to_s.ljust(10)}   -#{data['-'].to_s.ljust(10)} = #{data['+'] - data['-']}" } * "\n"

added = stats.sum{|a,d| d['+'] }
removed = stats.sum{|a,d| d['-'] }
puts "Sum: +#{added} -#{removed} = #{added - removed} lines"
puts "Took #{Time.now.to_i - start} seconds"