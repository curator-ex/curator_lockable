defmodule CuratorLockable.PlugTest do
  use ExUnit.Case, async: true
  doctest CuratorLockable.Plug

  use Plug.Test

  import CuratorLockable.Test.PlugHelper

  setup do
    conn = conn_with_fetched_session(conn(:get, "/"))
    {:ok, %{conn: conn}}
  end

  test "with an inactive user", %{conn: conn} do
    user = %{locked_at: Timex.now}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> Curator.PlugHelper.set_current_resource(user)
    |> run_plug(CuratorLockable.Plug)

    refute Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn, :default) == {:error, "Account Locked"}
  end

  test "with an active user", %{conn: conn} do
    user = %{locked_at: nil}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> Curator.PlugHelper.set_current_resource(user)
    |> run_plug(CuratorLockable.Plug)

    assert Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn) == {:ok, %{claims: "default"}}
  end

  test "with no user", %{conn: conn} do
    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> run_plug(CuratorLockable.Plug)

    refute Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn) == {:ok, %{claims: "default"}}
  end
end
