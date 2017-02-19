defmodule CuratorLockable.Config do
  @moduledoc """
  The configuration for CuratorLockable.

  ## Configuration

      config :curator_lockable, CuratorLockable,
        repo: CuratorLockable.Test.Repo,
        user_schema: CuratorLockable.Test.User,
        token_expiration: [minutes: 30],
        maximum_attempts: 5

  """

  def repo do
    config(:repo, Curator.Config.repo)
  end

  def user_schema do
    config(:user_schema, Curator.Config.user_schema)
  end

  def token_expiration do
    config(:token_expiration, [minutes: 30])
  end

  def maximum_attempts do
    config(:maximum_attempts, 5)
  end

  @doc false
  def config, do: Application.get_env(:curator_lockable, CuratorLockable, [])
  @doc false
  def config(key, default \\ nil),
    do: config() |> Keyword.get(key, default) |> resolve_config(default)

  defp resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  defp resolve_config(value, _default),
    do: value
end
