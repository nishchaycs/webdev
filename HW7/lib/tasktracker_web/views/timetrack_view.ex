defmodule TasktrackerWeb.TimetrackView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimetrackView

  def render("index.json", %{timetracks: timetracks}) do
    %{data: render_many(timetracks, TimetrackView, "timetrack.json")}
  end

  def render("show.json", %{timetrack: timetrack}) do
    %{data: render_one(timetrack, TimetrackView, "timetrack.json")}
  end

  def render("timetrack.json", %{timetrack: timetrack}) do
    %{id: timetrack.id,
      start_time: timetrack.start_time,
      end_time: timetrack.end_time}
  end
end
