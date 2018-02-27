defmodule TasktrackerWeb.TimetrackControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.Tracker
  alias Tasktracker.Tracker.Timetrack

  @create_attrs %{end_time: ~N[2010-04-17 14:00:00.000000], start_time: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{end_time: ~N[2011-05-18 15:01:01.000000], start_time: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{end_time: nil, start_time: nil}

  def fixture(:timetrack) do
    {:ok, timetrack} = Tracker.create_timetrack(@create_attrs)
    timetrack
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all timetracks", %{conn: conn} do
      conn = get conn, timetrack_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create timetrack" do
    test "renders timetrack when data is valid", %{conn: conn} do
      conn = post conn, timetrack_path(conn, :create), timetrack: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, timetrack_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2010-04-17 14:00:00.000000],
        "start_time" => ~N[2010-04-17 14:00:00.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, timetrack_path(conn, :create), timetrack: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update timetrack" do
    setup [:create_timetrack]

    test "renders timetrack when data is valid", %{conn: conn, timetrack: %Timetrack{id: id} = timetrack} do
      conn = put conn, timetrack_path(conn, :update, timetrack), timetrack: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, timetrack_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "end_time" => ~N[2011-05-18 15:01:01.000000],
        "start_time" => ~N[2011-05-18 15:01:01.000000]}
    end

    test "renders errors when data is invalid", %{conn: conn, timetrack: timetrack} do
      conn = put conn, timetrack_path(conn, :update, timetrack), timetrack: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete timetrack" do
    setup [:create_timetrack]

    test "deletes chosen timetrack", %{conn: conn, timetrack: timetrack} do
      conn = delete conn, timetrack_path(conn, :delete, timetrack)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, timetrack_path(conn, :show, timetrack)
      end
    end
  end

  defp create_timetrack(_) do
    timetrack = fixture(:timetrack)
    {:ok, timetrack: timetrack}
  end
end
