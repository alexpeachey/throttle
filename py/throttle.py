import threading

class Limiter:
  pass

def throttle(f, interval):
  limiter = Limiter()
  limiter.limited = False
  def wrapped(*args):
    if limiter.limited:
      return
    else:
      limiter.limited = True
      def reset():
        limiter.limited = False
      threading.Timer(interval/1000, reset).start()
      return f(*args)
  return wrapped
