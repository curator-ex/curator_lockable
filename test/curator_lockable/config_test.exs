defmodule CuratorLockable.ConfigTest do
  use ExUnit.Case, async: true
  doctest CuratorLockable.Config

  test "the repo" do
    assert CuratorLockable.Config.repo == CuratorLockable.Test.Repo
  end

  test "the user_schema" do
    assert CuratorLockable.Config.user_schema == CuratorLockable.Test.User
  end

  test "the token_expiration" do
    assert CuratorLockable.Config.token_expiration == [minutes: 30]
  end

  test "the maximum_attempts" do
    assert CuratorLockable.Config.maximum_attempts == 5
  end
end
