# ColonelKurtzEx

`ColonelKurtzEx` facilitates working with the block content editor [Colonel Kurtz](https://github.com/vigetlabs/colonel-kurtz) in [Phoenix](https://www.phoenixframework.org/) applications.

[Documentation](http://code.viget.com/colonel_kurtz_ex/) is available on GitHub and will be on HexDocs soon!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed by adding `colonel_kurtz_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:colonel_kurtz_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc) and published on [HexDocs](https://hexdocs.pm). Once published, the docs can be found at [https://hexdocs.pm/colonel_kurtz_ex](https://hexdocs.pm/colonel_kurtz_ex).

## Development

### Code Quality

To support high code quality this project uses [dialyxir](https://github.com/jeremyjh/dialyxir) and [credo](https://github.com/rrrene/credo) for static code analysis and [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) for testing.

#### Typespecs

    mix dialyzer

#### Code Style
    mix credo --strict

#### Tests
    mix test

## Contributing

1. [Fork](http://github.com/vigetlabs/colonel_kurtz_ex/fork) the library
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

- Solomon Hawk (@solomonhawk)
- Dylan Lederle-Ensign (@dlederle)

## License

ColonelKurtzEx is released under the MIT License. See the LICENSE file for further details.
