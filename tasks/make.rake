desc "rake install && rake build:checksum && bundle info aromancer"
task :make do
  exec "rake install && rake build:checksum && bundle info aromancer"
end
