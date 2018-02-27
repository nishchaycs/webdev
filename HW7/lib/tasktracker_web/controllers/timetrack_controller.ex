defmodule TasktrackerWeb.TimetrackController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Tracker
  alias Tasktracker.Tracker.Timetrack

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    timetracks = Tracker.list_timetracks()
    render(conn, "index.json", timetracks: timetracks)
  end

  def create(conn, %{"timetrack" => timetrack_params}) do
    with {:ok, %Timetrack{} = timetrack} <- Tracker.create_timetrack(timetrack_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", timetrack_path(conn, :show, timetrack))
      |> render("show.json", timetrack: timetrack)
    end
  end

  def show(conn, %{"id" => id}) do
    timetrack = Tracker.get_timetrack!(id)
    render(conn, "show.json", timetrack: timetrack)
  end

  def update(conn, %{"id" => id, "timetrack" => timetrack_params}) do
    timetrack = Tracker.get_timetrack!(id)

    with {:ok, %Timetrack{} = timetrack} <- Tracker.update_timetrack(timetrack, timetrack_params) do
      render(conn, "show.json", timetrack: timetrack)
    end
  end

  def delete(conn, %{"id" => id}) do
    timetrack = Tracker.get_timetrack!(id)
    with {:ok, %Timetrack{}} <- Tracker.delete_timetrack(timetrack) do
      send_resp(conn, :no_content, "")
    end
  end
end
