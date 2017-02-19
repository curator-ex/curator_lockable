use Mix.Config

config :logger, level: :warn

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorLockable.Test.GuardianSerializer

config :curator_lockable, CuratorLockable,
  repo: CuratorLockable.Test.Repo,
  user_schema: CuratorLockable.Test.User

config :curator_lockable, ecto_repos: [CuratorLockable.Test.Repo]

config :curator_lockable, CuratorLockable.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/curator_lockable_test",
  size: 1,
  max_overflow: 0,
  priv: "test/support"
