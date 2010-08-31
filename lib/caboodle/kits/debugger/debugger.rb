module Caboodle
  class Debugger < Caboodle::Kit
    
    Caboodle::Debug.each do |debug|
      Caboodle::Layout.below_footer = "<div id='debug'>"
      Caboodle::Layout.below_footer << "<p>#{debug}</p>"
      Caboodle::Layout.below_footer << "</div>"
    end
    
  end
end

