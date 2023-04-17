defmodule FoodTruck.FoodTrucksTest do
  use ExUnit.Case, async: true
  alias FoodTruck.FoodTruck
  import Tesla.Mock

  doctest FoodTruck

  @base_url Application.compile_env(:food_truck, :sfdata_url)

  describe "list_trucks/0" do
    test "requests all trucks with approved status" do
      mock(fn
        %{method: :get, url: @base_url, query: [status: "APPROVED"]} ->
          %Tesla.Env{status: 200, body: []}
      end)

      assert FoodTruck.list_trucks() == {:ok, []}
    end

    test "handles a 404 status" do
      mock(fn
        %{method: :get, url: @base_url, query: [status: "APPROVED"]} ->
          %Tesla.Env{status: 404, body: []}
      end)

      assert FoodTruck.list_trucks() == {:error, 404}
    end

    test "returns a formatted list of food trucks" do
      mock(fn
        %{method: :get, url: @base_url, query: [status: "APPROVED"]} ->
          %Tesla.Env{status: 404, body: []}
      end)
    end
  end
end
