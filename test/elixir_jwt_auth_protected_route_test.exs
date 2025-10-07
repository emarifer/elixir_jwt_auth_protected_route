defmodule ElixirJwtAuthProtectedRouteTest do
  use ExUnit.Case
  doctest ElixirJwtAuthProtectedRoute

  test "greets the world" do
    assert ElixirJwtAuthProtectedRoute.hello() == :world
  end
end
