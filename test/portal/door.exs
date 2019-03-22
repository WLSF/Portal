defmodule Portal.DoorTest do
  use ExUnit.Case
  doctest Portal.Door

  describe "Given a door color" do
    test "starts a link" do
      {status, _} = Portal.Door.start_link(:green)
      assert status == :ok
    end
  
    test "gets the current data" do
      Portal.Door.start_link(:green)
      assert Portal.Door.get(:green) == []
    end
  
    test "pushes data inside" do
      Portal.Door.start_link(:green)
      assert Portal.Door.push(:green, 5) == :ok
      assert Portal.Door.get(:green) == [5]
    end

    test "pops data inside" do
      Portal.Door.start_link(:green)
      assert Portal.Door.push(:green, 5) == :ok
      assert Portal.Door.push(:green, 7) == :ok
      assert Portal.Door.get(:green) == [7, 5]
      assert Portal.Door.pop(:green) == {:ok, 7}
    end
  end
end
