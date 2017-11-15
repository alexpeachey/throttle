defmodule Curry do

  def curry(f) do
    {_, arity} = :erlang.fun_info(f, :arity)
    curry(f, arity, [])
  end

  def curry(f, 0, arguments) do
    apply(f, Enum.reverse arguments)
  end

  def curry(f, arity, arguments) do
    fn arg -> curry(f, arity - 1, [arg | arguments]) end
  end

end
