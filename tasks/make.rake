desc "rake install && rake build:checksum && bundle info aro"
task :make do
  exec "rake install && rake build:checksum && bundle info aro"
end
