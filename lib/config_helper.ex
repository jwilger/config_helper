defmodule ConfigHelper do
  @moduledoc """
  Helper functions used in config/runtime.exs
  """

  @type config_type :: :str | :int | :bool | :json | :atom

  @doc """
  Get value from environment variable, converting it to the given type if needed.

  If no default value is given, or `:no_default` is given as the default, an error is raised if the variable is not
  set.
  """
  @spec get_env(String.t(), :no_default | any(), config_type()) :: any()
  def get_env(var, default \\ :no_default, type \\ :str)

  def get_env(var, :no_default, type) do
    var
    |> System.fetch_env!()
    |> get_with_type(type)
  end

  def get_env(var, default, type) do
    case System.fetch_env(var) do
      {:ok, val} -> get_with_type(val, type)
      :error -> default
    end
  end

  @doc """
  Remove the `sslmode` query parameter from a URI

  This is particularly needed to deploy a Commanded app to Fly.io when using
  the `commanded/event_store` library, because Fly.io automatically addes the
  sslmode param and the event store library does not support it (raises an
  ArgumentError if it is present.)

  See: https://github.com/commanded/eventstore/issues/265
  """
  @spec remove_sslmode_from_uri(String.t() | URI.t()) :: String.t()
  def remove_sslmode_from_uri(uri) when is_binary(uri) do
    uri
    |> URI.parse()
    |> remove_sslmode_from_uri()
  end

  def remove_sslmode_from_uri(%URI{query: query} = uri) when is_binary(query) do
    query
    |> URI.decode_query()
    |> Map.delete("sslmode")
    |> URI.encode_query()
    |> then(&Map.merge(uri, %{query: &1}))
    |> URI.to_string()
  end

  def remove_sslmode_from_uri(%URI{} = uri), do: URI.to_string(uri)

  @doc """
  Make a test database URL by appending `_test_<partition>` to the path of the given URI
  """
  @spec make_test_database_url(String.t() | URI.t(), String.t()) :: String.t()
  def make_test_database_url(database_url, mix_test_partition) when is_binary(database_url) do
    database_url
    |> URI.parse()
    |> make_test_database_url(mix_test_partition)
  end

  def make_test_database_url(%URI{} = uri, mix_test_partition) do
    URI.to_string(%{uri | path: "#{uri.path}_test_#{mix_test_partition}"})
  end

  @spec get_with_type(String.t(), config_type()) :: any()
  defp get_with_type(val, type)

  defp get_with_type(val, :str), do: val
  defp get_with_type(val, :int), do: String.to_integer(val)
  defp get_with_type("true", :bool), do: true
  defp get_with_type("false", :bool), do: false
  defp get_with_type(val, :json), do: Jason.decode!(val)
  defp get_with_type(val, :atom), do: String.to_existing_atom(val)

  # Takes a string in the form `"one, two, three"` and turns it into a list,
  # `["one", "two", "three"]`
  defp get_with_type(val, :str_list) do
    val
    |> String.split(",")
    |> Enum.map(fn topic -> String.trim(topic) end)
  end

  defp get_with_type(val, type), do: raise("Cannot convert to #{inspect(type)}: #{inspect(val)}")
end
