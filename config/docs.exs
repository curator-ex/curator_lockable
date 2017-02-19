use Mix.Config

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorLockable.TestGuardianSerializer

# config :curator_lockable, CuratorLockable,
#        repo: CuratorLockable.Test.Repo,
#        user_schema: CuratorLockable.Test.User

# config :curator_lockable, ecto_repos: [CuratorLockable.Test.Repo]

# config :curator_lockable, CuratorLockable.Test.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   username: "postgres",
#   password: "",
#   database: "curator_lockable_docs",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox,
#   priv: "test/support"
