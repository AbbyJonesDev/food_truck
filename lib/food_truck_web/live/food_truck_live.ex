defmodule FoodTruckWeb.FoodTruckLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use Phoenix.LiveView
  import FoodTruckWeb.CoreComponents

  def render(assigns) do
    ~H"""
    <h1 class="text-center">Food Trucks!</h1>
    <%= if @loading do %>
      <p class="text-center">Try not to be hangry - fetching the food trucks now!</p>
    <% end %>

    <.table id="trucks" rows={@trucks}>
      <:col :let={truck} label="ID"><%= truck.id %></:col>
      <:col :let={truck} label="Name"><%= truck.name %></:col>
      <:col :let={truck} label="Address"><%= truck.address %></:col>
      <:col :let={truck} label="Menu"><%= truck.menu %></:col>
      <:col :let={truck} label="Newish?"><%= !truck.has_prior_permit? %></:col>
    </.table>
    """
  end

  def mount(_params, _request, socket) do
    # {:ok, assign(socket, :temperature, temperature)}
    if connected?(socket) do
      {:ok, trucks} = FoodTruck.FoodTruck.list_trucks()
      {:ok, assign(socket, trucks: trucks, loading: false)}
    else
      {:ok, assign(socket, loading: true, trucks: [])}
    end
  end
end
