defmodule Creative.TestContextAgent do
  use Agent

  def start_link(initial_state \\ []) do
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  def add_name(name) do
    Agent.update(__MODULE__, fn state -> [name | state] end)
  end

  def name_exists?(name) do
    Agent.get(__MODULE__, fn state -> Enum.member?(state, name) end)
  end
end
