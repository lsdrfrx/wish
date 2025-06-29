require "./wish/shell"
require "./wish/history"

Dir.cd(ENV["HOME"])

while true
  command = Shell.read_command
  Shell.eval_command(command)
end
