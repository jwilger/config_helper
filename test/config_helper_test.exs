defmodule ConfigHelperTest do
  use ExUnit.Case
  alias ConfigHelper

  describe "get_env/3" do
    setup do
      System.put_env("TEST_VAR_STR", "test_value")
      System.put_env("TEST_VAR_INT", "123")
      System.put_env("TEST_VAR_BOOL", "true")
      System.put_env("TEST_VAR_JSON", "{\"key\": \"value\"}")
      System.put_env("TEST_VAR_ATOM", "atom_value")
      :ok
    end

    test "returns the value as string by default" do
      assert ConfigHelper.get_env("TEST_VAR_STR") == "test_value"
    end

    test "returns the value as integer" do
      assert ConfigHelper.get_env("TEST_VAR_INT", :no_default, :int) == 123
    end

    test "returns the value as boolean" do
      assert ConfigHelper.get_env("TEST_VAR_BOOL", :no_default, :bool) == true
    end

    test "returns the value as JSON" do
      assert ConfigHelper.get_env("TEST_VAR_JSON", :no_default, :json) == %{"key" => "value"}
    end

    test "returns the value as atom" do
      assert ConfigHelper.get_env("TEST_VAR_ATOM", :no_default, :atom) == :atom_value
    end

    test "returns the default value if env var is not set" do
      assert ConfigHelper.get_env("NON_EXISTENT_VAR", "default_value") == "default_value"
    end

    test "raises an error if env var is not set and no default is provided" do
      assert_raise System.EnvError, fn ->
        ConfigHelper.get_env("NON_EXISTENT_VAR", :no_default)
      end
    end
  end

  describe "remove_sslmode_from_uri/1" do
    test "removes sslmode from URI string" do
      uri = "postgres://user:pass@localhost/db?sslmode=require"
      expected = "postgres://user:pass@localhost/db?"
      assert ConfigHelper.remove_sslmode_from_uri(uri) == expected
    end

    test "returns URI string unchanged if no sslmode" do
      uri = "postgres://user:pass@localhost/db"
      assert ConfigHelper.remove_sslmode_from_uri(uri) == uri
    end

    test "removes sslmode from URI struct" do
      uri = URI.parse("postgres://user:pass@localhost/db?sslmode=require")
      expected = "postgres://user:pass@localhost/db?"
      assert ConfigHelper.remove_sslmode_from_uri(uri) == expected
    end

    test "returns URI struct unchanged if no sslmode" do
      uri = URI.parse("postgres://user:pass@localhost/db")
      assert ConfigHelper.remove_sslmode_from_uri(uri) == URI.to_string(uri)
    end
  end

  describe "make_test_database_url/2" do
    test "appends _test_<partition> to URI string" do
      uri = "postgres://user:pass@localhost/db"
      partition = "1"
      expected = "postgres://user:pass@localhost/db_test_1"
      assert ConfigHelper.make_test_database_url(uri, partition) == expected
    end

    test "appends _test_<partition> to URI struct" do
      uri = URI.parse("postgres://user:pass@localhost/db")
      partition = "1"
      expected = "postgres://user:pass@localhost/db_test_1"
      assert ConfigHelper.make_test_database_url(uri, partition) == expected
    end
  end
end
