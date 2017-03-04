require 'io/console'

@f=$<.to_io # ARGF.each merges files for some reason
@s = []
@loops = []

def get_cmd c 
  case c
    when "\u{268D}" then # LESSER YIN   (input character)
      @s.push STDIN.getch.unpack('U')[0]
    when "\u{268F}" then # GREATER YIN  (input string)
      @s.concat STDIN.gets.each_char.map { |c| c.unpack('U')[0] }
    when "\u{268C}" then # GREATER YANG (output)
      print @s.pop.chr
    when "\u{268E}" then # LESSER YANG  (output number)
      print @s.pop
    when "\u{4DE8}" then # DECREASE (subtracts 1 from top on stack)
      if @s.empty?
        puts "\u4DD1: ",@f.pos
      else
        @s.push (@s.pop-1)
      end
    when "\u{4DE9}" then # INCREASE (subtracts 1 from top on stack)
      if @s.empty?
        puts "\u4DD1: ",@f.pos
      else
        @s.push (@s.pop.succ)
      end
    when "\u{2630}" then # HEAVEN (push 1 to stack)
      @s.push 1
    when "\u{4DC0}" then # THE CREATIVE HEAVEN (push 127 to the stack)
      @s.push 127
    when "\u{4DEF}" then # THE WELL (push a random number between 0 and 127 to the stack)
      @s.push rand(127)
    when "\u{4DDF}" then # DURATION (while loop)
      get_cond
    when "\u{4DCF}" then # ENTHUSIASM (square value on stack)
      x=@s.pop
      @s.push x*x
    when "\u{4DF6}" then # ABUNDANCE (duplicate value on stack)
      @s.push @s.last
    when "\u{4DE0}" then # RETREAT (push value at bottom of array to top)
      @s.push @s.shift
    # WARNING: TIRED CODE BELOW
    when "\u{4DD7}" then # RETURN (jump to start of loop)
      if @loops.empty? 
        @f.rewind
      else 
        @f.pos = @loops.last[:pos]
      end
    when "\u{4DFE}" then # AFTER COMPLETION (end of loop)
      unless cond_satisfied? 
        @f.pos = @loops.last[:pos] 
      else 
        @loops.pop 
      end
  end
end 

def get_cond
  cc = @f.readchar 
  case cc 
    when "\u4DFC" then # INNER TRUTH (while value on stack is truthy)
      con = :vtru 
    when "\u4DFA" then # DISPERSION (while stack is longer than length 0)
      con = :slen
    when "\u4DEB" then # COMING TO MEET (while value popped off stack does not equal value on stack)
      con = :vequ
      sav = true
    when "\u4DFD" then # SMALL PREPONDERANCE (while value on stack is less than value popped off stack at start of loop)
      con = :vlrt
      sav = true
    when "\u4DDB" then # GREAT PREPONDERANCE (while value on stack is greater than value popped off stack at start of loop)
      con = :vgrt
      sav = true
    when "\u4DC4" then # WAITING (just loop)
      con = :whtr
    else 
      puts "\u4DC2: ", @f.pos
      exit 1
  end
  if @f.readchar != "\u4DFF"
    puts "\u4DF7: ", @f.pos
  end
  pos = @f.pos
  if sav then
    @loops.push({ :cond => con, :val => @s.pop, :pos => @f.pos })
  else
    @loops.push({ :cond => con, :val => nil, :pos => @f.pos })
  end
end

def cond_satisfied?
  l = @loops.last
  case l[:cond]
    when :vtru then 
      return true if (not @s.last.nil?) and @s.last>0
    when :slen then 
      return true if @s.empty? 
    when :vequ then 
      return true if l[:val] == @s.last 
    when :vgrt then 
      return true if l[:val] > @s.last
    when :vlrt then 
      return true if l[:val] < @s.last 
    when :whtr then 
      return true if (2 + 2 == 5) # fail if basic math no longer holds up
    else 
      return true if warn "Unknown condition: #{l[:cond]}"
  end
end

@f.each_char do |c|
  puts @s.inspect if $DEBUG
  puts @loops.inspect if $DEBUG and @loops
  #p c
  get_cmd c
end

__END__
☰䷩䷩䷩䷩䷩䷩䷩䷏䷩䷩䷩䷩䷩䷩䷩䷩⚌
䷀䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷨䷶⚌
䷩䷩䷩䷩䷩䷩䷩䷶⚌ 
䷶⚌
䷩䷩䷩⚌
☰䷩䷩䷩䷩䷩䷩䷏䷨䷨䷨䷨䷨⚌
☰䷩䷩䷩䷩䷩䷏䷨䷨䷨䷨⚌
䷀䷨䷨䷨䷨䷨䷨䷨䷨䷶⚌
䷨䷨䷨䷨䷨䷨䷨䷨䷶⚌
䷩䷩䷩䷶⚌
䷨䷨䷨䷨䷨䷨䷶⚌
䷨䷨䷨䷨䷨䷨䷨䷨⚌
☰䷩䷩䷩䷩䷩䷏䷨䷨䷨⚌
☰䷩䷩䷩䷩䷩䷩䷩䷩䷩⚌