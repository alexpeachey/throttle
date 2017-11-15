const throttle = (f, interval) => {
  let timeout;
  return (...args) => {
    if (timeout) return;
    timeout = setTimeout(() => { timeout = null;}, interval);
    return f.apply(this, args);
  }
}

export default throttle;
