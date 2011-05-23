class Browser
  attr_reader :the_request

  def initialize( the_request )
    @the_request = the_request
  end
  
class << self  
  def name( the_request )
    #
      browser = the_request.user_agent
      
      if browser.match(/(Firefox)/)
      	browser = "Firefox"
      elsif browser.match(/(iPhone)/)
      	browser = "iPhone"
      elsif browser.match(/(MSIE)/)
      	browser = "Internet Explorer"
      elsif browser.match(/(Chrome)/)
      	browser = "Chrome"
      elsif browser.match(/(Safari)/)
      	browser = "Safari"
      elsif browser.match(/(Opera)/)
      	browser = "Opera"
      else
      	browser = "Other"
      end
  
    return browser
  end
  
  def id( the_request)
    
      browser = the_request.user_agent
      
      if browser.match(/(Firefox)/)
      	browser = "ff"
      elsif browser.match(/(iPhone)/)
      	browser = "generic"
      elsif browser.match(/(MSIE)/)
      	browser = "ie"
      elsif browser.match(/(Chrome)/)
      	browser = "ch"
      elsif browser.match(/(Safari)/)
      	browser = "generic"
      elsif browser.match(/(Opera)/)
      	browser = "op"
      else
      	browser = "generic"
      end
  
    return browser
  end
  
  def os( the_request )
    
    browser = the_request.user_agent
    
    if browser.match(/(Mac)/)
      os = "MacOS"
    elsif browser.match(/(iPhone)/)
      os = "iPhone"
    elsif browser.match(/(Windows)/)
      os = "Windows"
    elsif browser.match(/(Linux)/)
      os = "Linux"
    else
      os = "Unknown"
    end
    return os
  end
  
  def version( the_request )
    # todo
    return "unknown"
  end

end  
end

