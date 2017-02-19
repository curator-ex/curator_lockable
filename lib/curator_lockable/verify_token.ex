defmodule CuratorLockable.VerifyToken do
  @moduledoc """
  """
  import Plug.Conn
  alias CuratorLockable.Config

  def init(opts \\ %{}) do
    opts = Enum.into(opts, %{})

    %{
      handler: Map.get(opts, :handler),
    }
  end

  def call(%{params: %{"id" => token}} = conn, opts) when not is_nil(token) do
    handler = Map.get(opts, :handler)

    user = Config.repo.get_by(Config.user_schema, unlock_token: token)

    case user do
      nil -> apply(handler, :token_error, [conn, :invalid])
      _ ->
        case CuratorLockable.unlock_token_expired?(user) do
          true -> apply(handler, :token_error, [conn, :expired])
          false -> Plug.Conn.put_private(conn, :curator_lockable_user, user)
        end
    end
  end

  def call(conn, opts) do
    handler = Map.get(opts, :handler)
    apply(handler, :token_error, [conn, :invalid])
  end
end
