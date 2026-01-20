require 'optparse'

begin
  msg = <<~TEXT

    \t\033[31m# Try one of these:\033[0m
    \033[32m\truby ~/dotfiles/tmux.rb bw|cb|cm|o|ps|s|sb|t

    \t# Start MySQL, Postgres, Redis
    \truby ~/dotfiles/tmux.rb t --start

    \t# Switch branch (default: "develop") and git pull
    \truby ~/dotfiles/tmux.rb t -branch=main
    \033[0m
  TEXT

  @options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: tmux.rb [options]#{msg}Options:"
    opts.on('-s', '--start', "\tStart MySQL, Postgres, Redis") do
      @options[:start] = true
    end

    opts.on('-b', '--branch[=BRANCH]', "\tSwitch branch (default: \"develop\") and git pull") do |opt|
      @options[:branch] = opt || 'develop'
    end
  end.parse!

  WORKSPACE = {
    o:   ['~/workspace/onboarder', 3, 'br -p 9999'],
    s:   ['~/workspace/ships', 3, ['export RAILS_MAX_THREADS=1; export WEB_CONCURRENCY=1; ./bin/rails s -b 0.0.0.0', 'NODE_ENV=development yarn build --watch']],
  }.freeze

  project = ARGV[0].to_sym
  workspace = '-c ' + WORKSPACE[project][0]
  more_windows = WORKSPACE[project][1]
  start_servers = Array(WORKSPACE[project][2])
rescue
  abort msg
end

# start servers
`~/.start-services` if @options[:start]

`tmux start-server`

`tmux new-session -d -s #{project} -n 1 #{workspace}`

more_windows.times do |i|
  `tmux new-window -t #{project}:#{i + 2} -n #{i + 2} #{workspace}`
end

(more_windows + 1).times do |i|

  # Opne vim in the first window if "branch" is no specified
  if i == 0 && !@options[:branch]
    `tmux send-keys -t #{project}:1 "nvim" C-m`
  end

  # Last window
  if i == more_windows
    start_servers.each_with_index do |start_server, si|
      # Select pane
      `tmux selectp -t #{project}:#{i + 1}`

      if si == 1
        `tmux split-window -h #{workspace}`
      end

      if si == 2
        `tmux split-window -v #{workspace}`
      end

      # Try to checkout the branch and pull
      if @options[:branch]
        cmds = ["git fetch origin #{@options[:branch]}", "git checkout #{@options[:branch]}", 'git pull']
        cmds << 'yarn install' if [:bw, :cb, :cm, :s, :sb].include?(project)
        cmds << 'rdm' if [:s, :t].include?(project)

        `tmux send-keys "#{cmds.join('; ')}" C-m`
      end

      # Run server
      `tmux send-keys "#{start_server}" C-m`
    end
  end
end
