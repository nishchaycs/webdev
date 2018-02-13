defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("game:" <> name, payload, socket) do
    game = Memory.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
    if authorized?(payload) do      
      {:ok, %{"game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("reset", %{}, socket) do
    game1 = Game.new()
    Memory.GameBackup.save(socket.assigns[:name], game1)
    socket = socket
      |> assign(:game, game1)
    {:reply, {:ok, %{"game" => Game.client_view(game1)}}, socket}
  end

  def handle_in("guess", %{"row" => row, "col" => col}, socket) do
    game0 = socket.assigns[:game]
    game1 = Game.handleTileClick(game0, row, col)
    Memory.GameBackup.save(socket.assigns[:name], game1)
    socket = socket
      |> assign(:game, game1)
    {:reply, {:ok, %{"game" => Game.client_view(game1)}}, socket}
  end

  def handle_in("nomatch", %{}, socket) do
    game0 = socket.assigns[:game]
    game1 = Game.flipBackTiles(game0)
    Memory.GameBackup.save(socket.assigns[:name], game1)
    socket = socket
      |> assign(:game, game1)
    {:reply, {:ok, %{"game" => Game.client_view(game1)}}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
