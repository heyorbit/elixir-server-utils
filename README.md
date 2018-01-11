[![Coverage Status](https://coveralls.io/repos/github/heyorbit/elixir-server-utils/badge.svg?branch=master)](https://coveralls.io/github/heyorbit/elixir-server-utils?branch=master)
[![Build Status](https://travis-ci.org/heyorbit/elixir-server-utils.svg?branch=master)](https://travis-ci.org/heyorbit/elixir-server-utils)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/heyorbit/elixir-server-utils.svg)](https://beta.hexfaktor.org/github/heyorbit/elixir-server-utils)

# ServerUtils

This project has several module utils to handle common tasks in a server, like authorization params parsing.

Features:

  * Phoenix plug to validate JWT header
  * Simple integer parsing
  * Page query params parser
  * JWT claims parser
  * Wrapped Logger with Sentry integration

# Configuration

Configure default pagination params

```
config :server_utils,
  page_size_key: "page_size",
  page_number_key: "page_number",
  max_page_size: 25,
  page_size: 10,
  page_number: 1
```
