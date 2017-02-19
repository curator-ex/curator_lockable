defmodule CuratorLockable.Schema do
  @moduledoc """
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro curator_lockable_schema do
    quote do
      field :failed_attempts, :integer, default: 0
      field :locked_at, Timex.Ecto.DateTime
      # field :unlock_token, :string
      # field :unlock_sent_at, Ecto.DateTime
    end
  end
end
