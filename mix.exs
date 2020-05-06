defmodule ColonelKurtz.MixProject do
  use Mix.Project

  def project do
    [
      app: :colonel_kurtz_ex,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      applications: applications(Mix.env()),
      compilers: compilers(Mix.env()),
      aliases: aliases(),
      dialyzer: dialyzer(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: [
        main: "readme",
        extras: ["README.md"],
        output: "docs"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def applications(:test), do: [:phoenix]
  def applications(_), do: []

  def compilers(:test), do: [:phoenix] ++ Mix.compilers
  def compilers(_), do: Mix.compilers

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:ecto_sql, "~> 3.4"},
      {:phoenix_html, "~> 2.11"},
      {:jason, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      types: []
    ]
  end

  defp dialyzer do
    [
      flags: [:error_handling, :race_conditions, :underspecs, :unmatched_returns],
      plt_add_apps: [:ex_unit, :mix],
      ignore_warnings: "config/.dialyzer_ignore.exs"
    ]
  end
end
