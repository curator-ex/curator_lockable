defmodule UsersMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string

      # Lockable
      add :failed_attempts, :integer, default: 0
      add :locked_at, :utc_datetime
      # add :unlock_token, :string
      # add :unlock_sent_at, :utc_datetime

      timestamps()
    end
    create unique_index(:users, [:email])
    # create unique_index(:users, [:unlock_token])
  end
end
