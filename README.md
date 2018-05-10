[![Coverage Status](https://coveralls.io/repos/github/heyorbit/elixir-server-utils/badge.svg?branch=master)](https://coveralls.io/github/heyorbit/elixir-server-utils?branch=master)
[![Hex version](https://img.shields.io/hexpm/v/sippet.svg "Hex version")](https://hex.pm/packages/server_utils)
[![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/server_utils)
[![Build Status](https://travis-ci.org/heyorbit/elixir-server-utils.svg?branch=master)](https://travis-ci.org/heyorbit/elixir-server-utils)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/heyorbit/elixir-server-utils.svg)](https://beta.hexfaktor.org/github/heyorbit/elixir-server-utils)

# ServerUtils

This project has several module utils to handle common tasks in a server, like authorization params parsing.

Features:

  * Phoenix plug to validate a JWT header
  * Pagination parsing:
    * Cursor pagination
    * Classic pagination
  * Simple integer parsing
  * JWT claims parser
  * Logger wrapper with [Sentry](https://sentry.io/welcome/) integration

## Installation

Add to dependencies

```elixir
def deps do
  [{:server_utils, "~> 0.2.0"}]
end
```

```bash
mix deps.get
```

## Configuration

### Pagination

Configure default pagination params:

* Classic pagination

```elixir
config :server_utils,
  page_size_key: "page_size",
  page_number_key: "page_number",
  max_page_size: 25,
  page_size: 10,
  page_number: 1
```

* Cursor pagination

```elixir
config :server_utils,
  cursor_key: "cursor",
  number_of_items_key: "number_of_items",
  default_cursor: "",
  default_number_of_items: 25,
  max_number_of_items: 50
```

## Usage

[Check the documentation](https://hexdocs.pm/server_utils) for the different available plugs.

### Pagination

Set the plug in your router file to use it in a pipeline:

```elixir
pipeline :paginated do
  plug(ServerUtils.Plugs.Pagination.Cursor.PageRequest)
end

scope "/" do
  pipe_through([:paginated])

  get("/stuff", MyApp.StuffController, :get_stuff)
end
```

Depending on the plug used, either a cursor or classic `PageRequest.t()` struct will be inject in the connection:

```elixir
defmodule MyApp.StuffController do
  use MyApp, :controller

  def get_stuff(conn, params) do
    cursor_page_request = conn.private[:server_utils][:page_request]
    # Some other code using the cursor page request...
  end
end
```

### Session

If the plug JWT is used, the authorization header will be validated and a struct `ServerUtils.Session.t` will be injected into the connection.

```elixir
pipeline :authenticated do
  plug(ServerUtils.Plugs.Session.JwtSession)
end

scope "/" do
  pipe_through([:authenticated])

  get("/protected_stuff", MyApp.StuffController, :get_protected_stuff)
end
```

```elixir
defmodule MyApp.StuffController do
  use MyApp, :controller

  def get_protected_stuff(conn, params) do
    cursor_page_request = conn.private[:server_utils][:session]

    # Some other code using the authenticated request...
  end
end
```
