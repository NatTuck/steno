defmodule Steno.Job do
  # Key:
  #  - Is unique, new replaces old.
  #  - For Inkfish: "#{7 digit sub_id}"

  # Pri:
  #  - Jobs will be sorted in ascending order by pri.
  #  - Could be useful to make this attempt #.

  # Status is one of:
  #   :ready, :running, :done
  #
  # Data contains:
  #   - sandbox: {...}   # Sandbox config
  #   - driver: ""       # URL of driver script
  #   - env: { }         # Environment vars for driver

  @derive {Phoenix.Param, key: :key}
  defstruct key: nil, pri: 10, idx: nil, container: %{}, driver: %{},
    output: %{}, postback: nil, status: :ready

  def keys() do
    struct(__MODULE__, %{})
    |> Map.drop([:__struct__])
    |> Map.keys
  end

  def atomize(mm, ks) do
    known = Enum.map(ks, &to_string/1)
    mm
    |> Enum.into([])
    |> Enum.filter(fn {kk, _vv} -> Enum.member?(known, kk) end)
    |> Enum.map(fn {kk, vv} -> {String.to_atom(kk), vv} end)
    |> Enum.into(%{})
  end

  def new(params) do
    struct!(__MODULE__, atomize(params, keys()))
  end
end
