# Engine

A Scumm file format parser written in Elixir for future consumption by UI

## Standalone

`iex -S mix`
`ScummIndex.parse`

Currently this will output a map of the file positions to retrieve assets from, no decoding of assets currently takes place or joins the dots into making it a playable game

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `engine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:engine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/engine](https://hexdocs.pm/engine).

