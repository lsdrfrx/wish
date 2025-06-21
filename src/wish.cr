require "./wish/shell"
require "./wish/history"

Dir.cd(ENV["HOME"])

while true
  command = Shell.read_command
  tokenized = Shell.tokenize_command command
  Shell.eval_command tokenized
end
