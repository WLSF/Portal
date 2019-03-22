defmodule Portal do
  defstruct [:left, :right]

  @doc """
  Starts transfering `data` from `left` to `right`.
  """
  def transfer(left, right, data) do
    for item <- data do
      Portal.Door.push(left, item)
    end

    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`.
  """
  def push_right(portal) do
    push_to(portal, portal.left)
  end

  @doc """
  Pushes data to the left in the given `portal`.
  """
  def push_left(portal) do
    push_to(portal, portal.right)
  end

  @doc """
  Pushes data to the given `direction` and `portal`.
  """
  def push_to(portal, direction) do
    case Portal.Door.pop(direction) do
      :error -> :ok
      {:ok, h} -> portal |> get_opposite_direction(direction) |> Portal.Door.push(h)
    end

    portal
  end

  def get_opposite_direction(portal, direction) do
    if direction == portal.left, do: portal.right, else: portal.left
  end

  @doc """
  Shoots a new door with the given `color`.
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
