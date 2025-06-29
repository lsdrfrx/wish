require "./history.cr"

module Shell
  def self.read_command : String
    print "#{Dir.current} $ "
    gets.to_s.chomp
  end

  def self.tokenize_command(command : String) : {String, Array(String)}
    parts = command.split(" ")
    {parts[0], parts[1..]}
  end

  def self.eval_command(raw_command : String)
    command, args = self.tokenize_command(raw_command)

    case command
    when "history"
      self.show_history
    when /^\!(\d+)$/
      index = $~[1..][0].to_i
      self.execute_history_command(index)
    when /^\!\!$/
      self.execute_previous_command
    when "exit"
      exit
    when "pwd"
      self.handle_pwd
    when "cd"
      target = args[0]
      self.handle_cd(target, raw_command)
    when ""
    else
      self.execute_system_command(command, args, raw_command)
    end
  end

  private def self.show_history
    history = History.get_all
    unless history.nil?
      history.each_with_index do |command, index|
        puts "#{index+1} #{command}"
      end
    end
  end

  private def self.execute_history_command(index : Int)
    cmd = History.get(index - 1)
    unless cmd.nil?
      self.eval_command(cmd)
    end
  end

  private def self.execute_previous_command
    cmds = History.get_all
    unless cmds.nil?
      self.eval_command(cmds[-1])
    end
  end

  private def self.execute_system_command(command : String, args : Array(String), raw_command : String)
    History.save raw_command
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

  private def self.handle_cd(target : String, raw_command : String)
    History.save raw_command
    begin
      Dir.cd target
    rescue ex : File::NotFoundError
      puts "Directory not found: #{target}"
    end
  end

  private def self.handle_pwd()
    History.save "pwd"
    puts Dir.current
  end
end
