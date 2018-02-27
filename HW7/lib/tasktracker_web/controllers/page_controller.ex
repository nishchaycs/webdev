defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def tasklist(conn, _params) do
  	tasks = Tasktracker.Tracker.list_tasks()
    render conn, "tasklist.html", tasks: tasks 
  end

  def userprofile(conn, _params) do
  	current_user = conn.assigns[:current_user]
  	underlings = Tasktracker.Accounts.list_underlings(current_user.id)
  	render conn, "userprofile.html", underlings: underlings
  end

  def tasktimeblocks(conn, task_params) do
    tasks = Tasktracker.Tracker.list_tasks()
    render conn, "timeblocks.html", tasks: tasks, task_id: task_params["task_id"], tb: Enum.at(tasks, String.to_integer(task_params["task_id"]) - 1).time_blocks
  end

end
