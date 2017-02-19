defmodule CuratorLockable.Test.Repo do
  use Ecto.Repo, otp_app: :curator_lockable

  def log(_cmd), do: nil
end
