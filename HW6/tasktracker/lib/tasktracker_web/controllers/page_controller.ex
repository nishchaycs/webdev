defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def tasklist(conn, _params) do
  	tasks = Tasktracker.Tracker.list_tasks()
    render conn, "tasklist.html", tasks: tasks 
  end

end
