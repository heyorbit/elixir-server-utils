# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :git_hooks,
  verbose: true,
  hooks: [
    pre_commit: [
      mix_tasks: [
        "format --check-formatted --dry-run",
        "credo"
      ]
    ],
    pre_push: [
      mix_tasks: [
        "dialyzer",
        "coveralls"
      ]
    ]
  ]

# Standard pagination
config :server_utils,
  page_size_key: "page_size",
  page_number_key: "page_number",
  max_page_size: 25,
  page_size: 10,
  page_number: 1

# Cursor pagination
config :server_utils,
  cursor_key: "cursor",
  number_of_items_key: "number_of_items",
  default_cursor: "",
  default_number_of_items: 25,
  max_number_of_items: 50
