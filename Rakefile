# -*- ruby -*-
ENV['RUBY_FLAGS'] = "-I#{%w(lib ext bin test).join(File::PATH_SEPARATOR)}"

require 'rake/gempackagetask'
require 'rubygems'

require 'lib/adhearsion/version'

TestGlob = ['spec/**/test_*.rb']

GEMSPEC = eval File.read("adhearsion.gemspec")

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.test_files = Dir[*TestGlob]
    t.output_dir = 'coverage'
    t.verbose = true
    t.rcov_opts.concat %w[--sort coverage --sort-reverse -x gems -x /var --no-validator-links]
  end
rescue LoadError
  STDERR.puts "Could not load rcov tasks -- rcov does not appear to be installed. Continuing anyway."
end

Rake::GemPackageTask.new(GEMSPEC).define

# YARD::Rake::YardocTask.new do |t|
#   t.files   = ['lib/**/*.rb']   # optional
#   # t.options = ['--any', '--extra', '--opts'] # optional
# end

desc "Run the unit tests for Adhearsion"
task :spec do
  Dir[*TestGlob].each do |file|
    load file
  end
end

desc "Used to regenerate the AMI source code files"
task :ragel do
  `ragel -n -R lib/adhearsion/voip/asterisk/ami/machine.rl | rlgen-ruby -o lib/adhearsion/voip/asterisk/ami/machine.rb`
end

desc "Compares Adhearsion's files with those listed in adhearsion.gemspec"
task :check_gemspec_files do
  
  files_from_gemspec    = ADHEARSION_FILES
  files_from_filesystem = Dir.glob(File.dirname(__FILE__) + "/**/*").map do |filename|
    filename[0...Dir.pwd.length] == Dir.pwd ? filename[(Dir.pwd.length+1)..-1] : filename
  end
  files_from_filesystem.reject! { |f| File.directory? f }
  
  puts
  puts 'Pipe this command to "grep -v \'spec/\' | grep -v test" to ignore test files'
  puts
  puts '##########################################'
  puts '## Files on filesystem not in the gemspec:'
  puts '##########################################'
  puts((files_from_filesystem - files_from_gemspec).map { |f| "  " + f })
  
  
  puts '##########################################'
  puts '## Files in gemspec not in the filesystem:'
  puts '##########################################'
  puts((files_from_gemspec - files_from_filesystem).map { |f| "  " + f })
end

desc "Test that the .gemspec file executes"
task :debug_gem do
  require 'rubygems/specification'
  gemspec = File.read('adhearsion.gemspec')
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n#{gemspec}") }.join
  puts "SUCCESS: Gemspec runs at the $SAFE level 3."
end
