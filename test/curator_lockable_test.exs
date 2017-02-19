defmodule CuratorLockableTest do
  use ExUnit.Case
  doctest CuratorLockable
  use CuratorLockable.TestCase

  alias CuratorLockable.Config

  setup do
    changeset = User.changeset(%User{}, %{
      name: "Test User",
      email: "test_user@test.com",
    })

    user = Repo.insert!(changeset)

    { :ok, %{
        user: user,
      }
    }
  end

  test "clear_lock_info!", %{user: user} do
    user = %{user | failed_attempts: Config.maximum_attempts - 1}
    assert user.failed_attempts == Config.maximum_attempts - 1
    refute user.locked_at

    user = CuratorLockable.clear_lock_info!(user)

    assert user.failed_attempts == 0
    refute user.locked_at
  end

  test "handle_failed_sign_in (when below maximum_attempts)", %{user: user} do
    assert user.failed_attempts == 0
    refute user.locked_at

    user = CuratorLockable.handle_failed_sign_in(user)

    assert user.failed_attempts == 1
    refute user.locked_at
  end

  test "handle_failed_sign_in (when reaching maximum_attempts)", %{user: user} do
    user = %{user | failed_attempts: Config.maximum_attempts - 1}
    assert user.failed_attempts == Config.maximum_attempts - 1
    refute user.locked_at

    user = CuratorLockable.handle_failed_sign_in(user)

    assert user.failed_attempts == Config.maximum_attempts
    assert user.locked_at
  end

  test "active_for_authentication? with a locked user" do
    user = %{locked_at: Timex.now}
    {:error, "Account Locked"} = CuratorLockable.active_for_authentication?(user)
  end

  test "active_for_authentication? with a unlocked user" do
    user = %{locked_at: nil}
    :ok = CuratorLockable.active_for_authentication?(user)
  end
end
