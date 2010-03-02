require 'yaml'

env = 'development'
app_config = YAML.load(File.open(File.dirname(__FILE__) + "/kamyshko.yml"))[ env ]

God.watch do |w|
  w.group = "#{app_config['app_name']}-delayed_job"
  w.name  = w.group + "-1"

  w.interval = 30.seconds

  w.uid = app_config['user']
  w.gid = app_config['group']

  w.start = "rake -f #{app_config['app_root']}/Rakefile jobs:work RAILS_ENV=#{env}"

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 1024.megabytes
      c.times = 2
      c.notify = 'developers'
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
      c.notify = 'developers'
    end
  end

end

God.watch do |w|
  w.group = "#{app_config['app_name']}-searchd"
  w.name  = w.group + "-1"

  w.interval = 30.seconds

  w.uid = app_config['user']
  w.gid = app_config['group']

  w.start         = "#{app_config['sphinx_bin_path']}/searchd --pidfile --config #{app_config['app_root']}/config/#{env}.sphinx.conf"
  w.start_grace   = 10.seconds
  w.stop          = "#{app_config['sphinx_bin_path']}/searchd --pidfile --config #{app_config['app_root']}/config/#{env}.sphinx.conf --stop"
  w.stop_grace    = 10.seconds
  w.restart       = w.stop + ' && ' + w.start
  w.restart_grace = 15.seconds

  w.pid_file = File.join(app_config['app_root'], "tmp/pids/searchd.#{env}.pid")

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval  = 5.seconds
      c.running   = false
      c.notify = 'developers'
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 1900.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
      c.notify = 'developers'
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state      = [:start, :restart]
      c.times         = 5
      c.within        = 5.minutes
      c.transition    = :unmonitored
      c.retry_in      = 10.minutes
      c.retry_times   = 5
      c.retry_within  = 2.hours
      c.notify = 'developers'
    end
  end

end
