module OsHelper
  
  def os
    case request.user_agent.downcase
    when /windows|win32/
      :windows
    when /linux/
      :linux
    else
      :mac
    end
  end
  
end
