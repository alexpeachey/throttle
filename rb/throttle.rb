module Throttle

  def self.throttle interval, f=nil, &block
    raise("Either a lambda or a block must be given") unless f || block_given?
    f ||= block
    limited = false
    -> (*args) do
      return nil if limited
      limited = true
      Thread.new do
        sleep(interval / 1000)
        limited = false
      end
      f.(*args)
    end
  end

end
