# ConfigHelper

ConfigHelper is a library providing utility functions for handling
configuration in Elixir projects.

## Features

- Fetch and convert environment variables to specified types.
- Remove the `sslmode` query parameter from a URI.
- Create test database URLs by appending a partition to the path.

## Installation

Add `config_helper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:config_helper, "~> 0.1.0"}
  ]
end
```

## Usage

### Fetching Environment Variables

```elixir
ConfigHelper.get_env("MY_ENV_VAR", :no_default, :int)
```

### Removing `sslmode` from URI

```elixir
ConfigHelper.remove_sslmode_from_uri("postgres://user:pass@localhost/db?sslmode=require")
```

### Creating Test Database URL

```elixir
ConfigHelper.make_test_database_url("postgres://user:pass@localhost/db", "1")
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE)
file for details.

## Contributing

If you have any questions or feedback, feel free to open an issue.
