defmodule Throttle do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def throttle(f, interval), do: throttle(:throttle, f, interval)
  def throttle(pid, f, interval), do: GenServer.call(pid, {:throttle, f, interval})

  def perform(f, args), do: perform(:throttle, f, args)
  def perform(pid, f, args), do: GenServer.call(pid, {:perform, f, args})

  def init(:ok) do
    {:ok, %{interval: nil, limited: false}}
  end

  def handle_call({:throttle, f, interval}, _from, state) do
    {_, arity} = :erlang.fun_info(f, :arity)
    g = Curry.curry(f)
    adapted = Adapt.adapt(fn(args) -> Throttle.perform(g, args) end, arity)
    {:reply, adapted, %{state | interval: interval, limited: false}}
  end
  def handle_call({:perform, _f, _args}, _from, %{limited: true}=state), do: {:reply, nil, state}
  def handle_call({:perform, f, args}, _from, state) do
    Process.send_after(self(), :reset, state.interval)
    {:reply, Enum.reduce(args, f, fn(arg, result) -> result.(arg) end), %{state | limited: true}}
  end

  def handle_info(:reset, state), do: {:noreply, %{state | limited: false}}
  def handle_info(_, state), do: {:ok, state}

end
