module Gify
  module_function
  def thor=(thor)
    @thor = thor
  end

  def shell
    @thor ? @thor.shell : nil
  end

  def options
    @thor ? @thor.options : {}
  end

  def verbose?
    !!options['verbose']
  end

  def say(message, options=nil)
    if shell
      shell.say message, options
    end
  end

  def say_status(status, message, options=nil)
    if shell
      shell.say_status status, message, options
    end
  end
end
