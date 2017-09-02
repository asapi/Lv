use Mix.Config
import System

env_config = fn(app, key, env) ->
  value = get_env env
  unless is_nil value do
    config app, key, value
  end
end


config :logger, level: :info

config :trot,
    router: Asapi.Router,
    pre_routing: [
      "Elixir.Trot.LiveReload": [env: Mix.env],
      "Elixir.Plug.Logger": [],
      "Elixir.Asapi.Library": [],
      "Elixir.PlugHeartbeat": [],
      "Elixir.Plug.Static": [at: "/", from: :asapi]
    ],
    post_routing: [
      "Elixir.Asapi.Reload": [],
      "Elixir.Asapi.Lv": [],
      "Elixir.Trot.NotFound": []
    ]

env_config.( :redix, :count, "REDIS_CONN_COUNT" )
env_config.( :redix, :url, "REDIS_URL" )

env_config.( :trot, :port, "PORT" )
