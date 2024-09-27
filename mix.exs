defmodule ConfigHelper.MixProject do
  use Mix.Project

  def project do
    [
      app: :config_helper,
      version: "1.0.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:mix_test_interactive, "~> 4.0", only: :dev, runtime: false}
    ]
  end
end
