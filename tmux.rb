# ruby ~/dotfiles/tmux.rb tripla
# ruby ~/dotfiles/tmux.rb tripla_cb
# ruby ~/dotfiles/tmux.rb tripla_bw
# ruby ~/dotfiles/tmux.rb tripla_sb
# ruby ~/dotfiles/tmux.rb tripla_cm
# ruby ~/dotfiles/tmux.rb ships
#
# ruby ~/dotfiles/tmux.rb tripla start

project = ARGV[0].to_sym
start = ARGV[1]

WORKSPACE = {
  sc: ['~/workspace/site-controller-api', 3, 'br -p 5000'],
  s:  ['~/workspace/ships', 3, 'br -p 4000'],
  t:  ['~/workspace/tripla', 3, 'br'],
  bw: ['~/workspace/tripla_booking_widget', 2, 'yarn server --port 8081'],
  cb: ['~/workspace/triplabot2.0', 2, 'yarn server --port 8080'],
  cm: ['~/workspace/tripla_frontend_app', 2, 'yarn server --port 8083'],
  sb: ['~/workspace/tripla_search_bar', 2, 'yarn server --port 8082']
}.freeze

workspace = WORKSPACE[project][0]
more_windows = WORKSPACE[project][1]
start_server = WORKSPACE[project][2]

# start servers
`~/start-services` if start == 'start'

`tmux start-server`

`tmux new-session -d -s #{project} -n 1`

more_windows.times do |i|
  `tmux new-window -t #{project}:#{i + 2} -n #{i + 2}`
end

(more_windows + 1).times do |i|
  `tmux send-keys -t #{project}:#{i + 1} "cd #{workspace}; export RBENV_VERSION=" C-m`

  if i == 0
    `tmux send-keys -t #{project}:1 "vim" C-m`
  end

  # last window
  if i == more_windows
    `tmux send-keys -t #{project}:#{i + 1} "#{start_server}" C-m`
  end
end
