defmodule CuratorLockable.Test.User do
  use Ecto.Schema
  import Ecto.Changeset

  use CuratorLockable.Schema

  schema "users" do
    field :name, :string
    field :email, :string

    curator_lockable_schema

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:email, :name])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
