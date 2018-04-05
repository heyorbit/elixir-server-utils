[![Coverage Status](https://coveralls.io/repos/github/heyorbit/elixir-server-utils/badge.svg?branch=master)](https://coveralls.io/github/heyorbit/elixir-server-utils?branch=master)
[![Hex version](https://img.shields.io/hexpm/v/sippet.svg "Hex version")](https://hex.pm/packages/server_utils)
[![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/server_utils)
[![Build Status](https://travis-ci.org/heyorbit/elixir-server-utils.svg?branch=master)](https://travis-ci.org/heyorbit/elixir-server-utils)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/heyorbit/elixir-server-utils.svg)](https://beta.hexfaktor.org/github/heyorbit/elixir-server-utils)

# ServerUtils

This project has several module utils to handle common tasks in a server, like authorization params parsing.

Features:

  * Phoenix plug to validate JWT header
  * Phoenix plug to parse a pagination request
  * Simple integer parsing
  * Page parsing:
    * Cursor pagination
    * Standard pagination
  * JWT claims parser
  * Wrapped Logger with Sentry integration

## Installation

Add to dependencies

```elixir
def deps do
  [{:server_utils, "~> 0.1.4"}]
end
```

```bash
mix deps.get
```

## Configuration

Configure default pagination params:

* Standard pagination

```
config :server_utils,
  page_size_key: "page_size",
  page_number_key: "page_number",
  max_page_size: 25,
  page_size: 10,
  page_number: 1
```

* Cursor pagination

```
config :server_utils,
  cursor_key: "cursor",
  number_of_items_key: "number_of_items",
  default_cursor: "",
  default_number_of_items: 25,
  max_number_of_items: 50
```
