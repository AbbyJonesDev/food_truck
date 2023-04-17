defmodule FoodTruck.FoodTruck do
  @moduledoc """
  The FoodTruck context.  Defines the FoodTruck data model and provides methods
  for requesting data about food trucks.
  """
  use Tesla

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger

  require Logger

  @base_url Application.compile_env(:food_truck, :sfdata_url)

  defstruct [:id, :name, :address, :menu, :latitude, :longitude, :has_prior_permit?]

  @type truck :: %{
          id: number,
          name: String.t(),
          address: String.t(),
          menu: String.t(),
          latitude: number,
          longitude: number,
          has_prior_permit?: boolean
        }

  @doc """
  Returns the list of trucks that have approved permits
  """
  @spec list_trucks() :: {:ok, [truck()]} | {:error, reason :: String.t()}
  def list_trucks do
    case get(@base_url, query: [status: "APPROVED"]) do
      {:ok, %{body: body, status: 200}} ->
        {:ok, Enum.map(body, &format_response/1)}

      {:ok, %{status: status}} ->
        Logger.error("Request failed with status #{status}")
        {:error, status}

      {:error, reason} ->
        Logger.error("Request failed with reason: #{reason}")
        {:error, reason}
    end
  end

  @doc """
  Takes the JSON response for one truck and converts it into a FoodTruck struct

  ## Examples

      iex> FoodTruck.format_response(%{"objectid" => "1660525", "applicant" => "Natan's Catering", "address" => "123 Main", "fooditems" => "Burgers", "latitude" => "37.7", "longitude" => "-122.3", "priorpermit" => "1" })
      %FoodTruck{
        id: 1660525,
        name: "Natan's Catering",
        address: "123 Main",
        menu: "Burgers",
        latitude: 37.7,
        longitude: -122.3,
        has_prior_permit?: true
      }
  """
  @spec format_response(map) :: %__MODULE__{
          address: String.t(),
          has_prior_permit?: false | nil | true,
          id: integer,
          latitude: nil | float,
          longitude: nil | float,
          menu: String.t(),
          name: String.t()
        }
  def format_response(raw) do
    %__MODULE__{
      id: String.to_integer(raw["objectid"]),
      name: raw["applicant"],
      menu: raw["fooditems"],
      address: raw["address"],
      latitude: coord_to_float(raw["latitude"]),
      longitude: coord_to_float(raw["longitude"]),
      has_prior_permit?: num_str_to_boolean(raw["priorpermit"])
    }
  end

  @doc """
  Converts a string representation of the latitude or longitude into a float.  If the value
  can't be parsed to a float, returns `nil` because no valid value is available.

  ## Examples

      iex> FoodTruck.coord_to_float("37.1234")
      37.1234

      iex> FoodTruck.coord_to_float("37")
      37.0

      iex> FoodTruck.coord_to_float("hi")
      nil
  """
  @spec coord_to_float(binary) :: nil | float
  def coord_to_float(str) do
    case Float.parse(str) do
      {val, _remainder} -> val
      _ -> nil
    end
  end

  @doc """
  Converts a string representation of "0" or "1" for true/false into a boolean value.  If the input is anything
  but "0" or "1," returns `nil` because no valid value is available.

  ## Examples

      iex> FoodTruck.num_str_to_boolean("0")
      false

      iex> FoodTruck.num_str_to_boolean("1")
      true

      iex> FoodTruck.num_str_to_boolean("hi")
      nil
  """
  @spec num_str_to_boolean(any) :: false | nil | true
  def num_str_to_boolean("0"), do: false
  def num_str_to_boolean("1"), do: true
  def num_str_to_boolean(_), do: nil
end
