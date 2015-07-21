cmd = "rails s"

pid = nil
timestamps = {}

Thread.new do
  while true
    pid = fork { exec cmd }
    Process.wait pid
  end
end

while true
  changed = []
  Dir["./config/**/*.yml"].each do |f|
    modified_at = File.stat(f).mtime
    changed << f  if timestamps[f] and modified_at != timestamps[f]

    timestamps[f] = modified_at
  end

  if ! changed.empty?
    puts "file(s) changed [#{changed.join(',')}], restarting"
    Process.kill "INT", pid
  end

  sleep 2
end

