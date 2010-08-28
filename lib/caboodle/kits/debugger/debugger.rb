module Caboodle
  class Debugger < Caboodle::Kit
    
    puts "Running debugger"
    puts Caboodle::Debug.inspect
    Caboodle::Debug.each do |debug|
      Caboodle::Layout.after_footer = "<div id='debug'>"
      Caboodle::Layout.after_footer << "<p>#{debug}</p>"
      Caboodle::Layout.after_footer << "</div>"
    end
    
    
  end
end

