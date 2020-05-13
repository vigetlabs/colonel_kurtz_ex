defmodule ColonelKurtz.MixProject do
  use Mix.Project

  def project do
    [
      app: :colonel_kurtz_ex,
      version: File.read!("VERSION") |> String.trim(),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      applications: applications(Mix.env()),
      aliases: aliases(),
      compilers: compilers(Mix.env()),
      dialyzer: dialyzer(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      docs: docs(),
      package: package(),
      source_url: "https://github.com/vigetlabs/colonel_kurtz_ex",
      description: description()
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

  def compilers(:test), do: [:phoenix] ++ Mix.compilers()
  def compilers(_), do: Mix.compilers()

  defp description do
    "ColonelKurtzEx facilitates working with the JavaScript block content editor [Colonel Kurtz](https://github.com/vigetlabs/colonel-kurtz) in Phoenix applications."
  end

  defp deps do
    [
      {:phoenix, "~> 1.4.17 or ~> 1.5.0"},
      {:ecto_sql, "~> 3.4"},
      {:phoenix_html, "~> 2.14"},
      {:jason, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test},
      {:cmark, "~> 0.7", only: :dev}
    ]
  end

  def aliases do
    [
      check: ["credo --strict", "dialyzer", "cmd MIX_ENV=test mix test"],
      types: ["dialyzer"]
    ]
  end

  defp dialyzer do
    [
      flags: [:error_handling, :race_conditions, :underspecs, :unmatched_returns],
      plt_add_apps: [:ex_unit, :mix],
      ignore_warnings: "config/.dialyzer_ignore.exs"
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      output: "docs",
      assets: "assets",
      before_closing_head_tag: &docs_before_closing_head_tag/1,
      markdown_processor: ExDoc.Markdown.Cmark
    ]
  end

  defp docs_before_closing_head_tag(:html) do
    ~s(<link rel="stylesheet" href="assets/docs.css" />)
  end

  defp docs_before_closing_head_tag(_), do: ""

  defp package do
    [
      name: "colonel_kurtz_ex",
      maintainers: ["Dylan Lederle-Ensign", "Solomon Hawk"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/vigetlabs/colonel_kurtz_ex",
        "Docs" => "http://code.viget.com/colonel_kurtz_ex/readme.html"
      },
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*)
    ]
  end
end
