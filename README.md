# FoodTruck

## Running the Project

**With Docker**

* Ensure that Docker desktop is installed and running
* Build initial Docker image: `docker-compose build`
* Set up database: `docker-compose run app mix setup`
* Start application and database together: `docker-compose up`
* View application at http://localhost:4000

**Without Docker**

* Project depends on [Elixir 1.14](https://elixir-lang.org/install.html) and [Postgres](https://www.postgresql.org)
* You may need to update the database information in `config/dev.exs` and `config/test.exs` to match your Postgres config
* Install dependencies and set up database: `mix setup`
* Run server: `mix phx.server` or inside IEx with `iex -S mix phx.server`
* View application at http://localhost:4000


## Helpful Commands

To run these commands in Docker, prefix them with `docker-compose run app`

* `mix dialyzer` - run static code analysis using Dialyxir. (This will take a bit the first time)
* `mix credo` - run static code analysis using Credo
* `mix deps.audit` - check for dependencies with known vulnerabilities
* `mix hex.audit` - check for dependencies that are no longer maintained
* `mix sobelow` - run static application security test

To run these commands in Docker, prefix them with `docker-compose run -e MIX_ENV=test app`

* `mix test` - run tests
* `mix coveralls` - report test coverage


## Phoenix Documentation

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix