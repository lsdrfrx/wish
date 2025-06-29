module History
  @@file_path = File.join(ENV["HOME"], ".wish_history")
  
  def self.save(command)
    begin
      File.open(@@file_path, "a") do |file|
        file.puts command
        file.flush
      end
    rescue ex
      STDERR.puts "Failed to write command to history: #{ex.message}"
    end
  end
  
  def self.get(index)
    begin
      File.read_lines(@@file_path)[index]
    rescue ex
      STDERR.puts "Failed to write command to history: #{ex.message}"
    end
  end

  def self.get_all()
    begin
      File.read_lines(@@file_path)
    rescue ex
      STDERR.puts "Failed to write command to history: #{ex.message}"
    end
  end
end
