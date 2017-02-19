defmodule CuratorLockable do
  @moduledoc """
  CuratorLockable: A curator module to handle user "locking".
  """

  if !(
       (Application.get_env(:curator_lockable, CuratorLockable) && Keyword.get(Application.get_env(:curator_lockable, CuratorLockable), :repo)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :repo))
      ), do: raise "CuratorLockable requires a repo"

  if !(
       (Application.get_env(:curator_lockable, CuratorLockable) && Keyword.get(Application.get_env(:curator_lockable, CuratorLockable), :user_schema)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :user_schema))
      ), do: raise "CuratorLockable requires a user_schema"

  alias CuratorLockable.Config

  def locked?(user) do
    case user.locked_at do
      nil -> false
      _ -> true
    end
  end

  def unlock(user) do
    user
    |> Ecto.Changeset.change(locked_at: nil)
    |> clear_lock_info_changeset
    |> Config.repo.update
  end

  def unlock!(user) do
    user
    |> Ecto.Changeset.change(locked_at: nil)
    |> clear_lock_info_changeset
    |> Config.repo.update!
  end

  def handle_failed_sign_in(%{locked_at: locked_at, failed_attempts: failed_attempts} = user) do
    failed_attempts = failed_attempts + 1

    user
    |> Ecto.Changeset.change(failed_attempts: failed_attempts)
    |> set_locked_at(failed_attempts, locked_at)
    |> Config.repo.update!
  end

  defp set_locked_at(changeset, failed_attempts, locked_at) do
    if failed_attempts >= Config.maximum_attempts do
      if locked_at do
        changeset
      else
        Ecto.Changeset.change(changeset, locked_at: Timex.now)
      end
    else
      changeset
    end
  end

  def active_for_authentication?(resource) do
    case locked?(resource) do
      true -> {:error, "Account Locked"}
      false -> :ok
    end
  end

  def clear_lock_info!(user) do
    user
    |> clear_lock_info_changeset
    |> Config.repo.update!
  end

  def clear_lock_info_changeset(changeset) do
    # Ecto.Changeset.change(changeset, unlock_token: nil, unlock_sent_at: nil, failed_attempts: 0)
    Ecto.Changeset.change(changeset, failed_attempts: 0)
  end

  def set_unlock_token!(user) do
    unlock_token = Curator.Token.generate
    unlock_sent_at = Timex.now

    user = user
    |> Ecto.Changeset.change(unlock_token: unlock_token, unlock_sent_at: unlock_sent_at)
    |> Config.repo.update!

    {user, unlock_token}
  end

  def unlock_token_expired?(%{unlock_sent_at: unlock_sent_at}) do
    Curator.Time.expired?(unlock_sent_at, Config.token_expiration)
  end

  def request_lockable_email_changeset(data, params \\ %{}) do
    import Ecto.Changeset
    types = %{email: :string}

    {data, types}
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
