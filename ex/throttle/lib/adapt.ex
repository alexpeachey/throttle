# From Jose Valim
defmodule Adapt do
  @doc """
     iex> myfun = fn(args) -> args end
     iex> myfun3 = Adapt.adapt(myfun, 3)
     iex> myfun3.(:a, :b, :c)
     [:a, :b, :c]
     iex> myfun2 = Adapt.adapt(myfun, 2)
     iex> myfun2.(:x, :y)
     [:x, :y]
  """
  def adapt(fun, arity)

  Enum.reduce(1..20, [], fn i, args ->
    args = [{ :"arg#{i}", [], nil }|args]

    def adapt(fun, unquote(i)) do
      fn unquote_splicing(args) -> fun.(unquote(args)) end
    end

    args
  end)
end
