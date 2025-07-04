require "./history.cr"
require "shellwords"

module Shell
  @@input_buffer = [] of Char
  @@cursor_position = 0
  @@prompt = "#{Dir.current} $ "

  private def self.redraw_line
    print "\r\e[K#{@@prompt}#{@@input_buffer.join}"
    print "\e[#{@@prompt.size + @@cursor_position + 1}G"
  end

  def self.read_command : String
    @@input_buffer.clear
    @@cursor_position = 0
    self.redraw_line

    loop do
      char = STDIN.raw &.read_char
      return "" unless char

      case char
      when 'q'
        exit
      when '\e', '\n'
        second = STDIN.raw &.read_char
        third = STDIN.raw &.read_char

        case {second, third}
        when {'[', 'C'}
          @@cursor_position += 1 if @@cursor_position < @@input_buffer.size
          self.redraw_line
        when {'[', 'D'}
          @@cursor_position -= 1 if @@cursor_position > 0
          self.redraw_line
        when {'[', 'A'}
          puts "UP"
        when {'[', 'B'}
          puts "DOWN"
        end
      when '\r'
        print '\n'
        break
      when '\b', 127.chr
        next if @@cursor_position == 0
        @@input_buffer.delete_at(@@cursor_position - 1)
        @@cursor_position -= 1
        self.redraw_line
      when '\u{3}'
        puts "\nEND OF TEXT (CTRL+C)"
        self.redraw_line
      when '\u{4}'
        puts "\nEND OF TRANSMISSION (CTRL+D)"
        self.redraw_line
      when '\u{1A}'
        puts "\nSUBSTITUTE (CTRL+Z)"
        self.redraw_line
      else
        @@input_buffer.insert(@@cursor_position, char)
        @@cursor_position += 1
        self.redraw_line
      end
    end
    return @@input_buffer.join
  end

  def self.tokenize_command(command : String) : {String, Array(String)}
    return {"", [] of String} if command == ""
    parts = Shellwords.shellsplit(command)

    command = parts[0]
    args = parts[1..]

    {command, args}
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
        puts "#{index + 1} #{command}"
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
      status = Process.run(
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

  private def self.handle_pwd
    History.save "pwd"
    puts Dir.current
  end
end
