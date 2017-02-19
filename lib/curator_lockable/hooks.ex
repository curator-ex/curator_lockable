defmodule CuratorLockable.Hooks do
  @moduledoc """
  This module hooks into the curator lifecycle.
  """

  use Curator.Hooks

  def before_sign_in(user, _type) do
    CuratorLockable.active_for_authentication?(user)
  end

  def after_sign_in(conn, user, _key) do
    CuratorLockable.clear_lock_info!(user)

    conn
  end

  def after_failed_sign_in(conn, nil, _key) do
    conn
  end

  def after_failed_sign_in(conn, user, _key) do
    CuratorLockable.handle_failed_sign_in(user)

    conn
  end
end
