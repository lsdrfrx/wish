module Shell
  def self.read_command
    print "#{Dir.current} $ "
    command = gets.not_nil!
    HISTORY << command
    return command
  end

  def self.tokenize_command(command)
    command.split(" ")
  end

  def self.eval_command(tokenized)
    command = tokenized[0]
    args = tokenized[1..]

    case command
    when "history"
      HISTORY.each_with_index {|entry, index| puts "#{index+1} #{entry}"}
    when "exit"
      exit
    when "pwd"
      puts Dir.current
    when "cd"
      begin
        target = args[0]
        Dir.cd target
      rescue ex : File::NotFoundError
        puts "Directory not found: #{target}"
      end
    else
      begin
        Process.run(
          command,
          args, 
          shell: false,
          output: STDOUT,
          error: STDERR,
          input: STDIN,
        )
      rescue ex : File::NotFoundError
        puts "Unknown command: #{command}"
      end
    end
  end

end
