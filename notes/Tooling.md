# Tooling

## Docker

I decided to include a Dockerfile.local and a docker-compose.yml file that would make it as easy as possible to get the project up and running locally.  This will allow reviewers to run the project without installing or configuring any additional dependencies and without verison conflicts if they have different versions of Elixir or Phoenix installed already.

I've configured shared volumes so that changes made locally are available in the running Docker container immediately, and the data saved in Postgres will be persisted when the application is shut down and restarted later.

I decided not to create a production Dockerfile as a part of this assessment.  There is a [generator](https://hexdocs.pm/phoenix/releases.html#containers) available that would create a production Dockerfile for me, and then I would just need to make tweaks depending on the target environment.  

## Code Quality

One of my favorite things about Elixir is the tooling included out of the box.  The ExUnit test framework and a formatter are included and ready to go, and the Phoenix library provides additional test helpers.

I've added these additional tools that I find helpful:

* [Dialyxir](https://github.com/jeremyjh/dialyxir) - static code analysis and type checking
* [Credo](https://github.com/rrrene/credo) - static code analysis and coaching on best practices
* [ExCoveralls](https://github.com/parroty/excoveralls) - code coverage reports
* [mix audit](https://hexdocs.pm/mix_audit/readme.html) - checks libraries for known vulnerabilites
* [hex audit](https://hexdocs.pm/hex/Mix.Tasks.Hex.Audit.html) - checks for libraries that are no longer maintained
* [Sobelow](https://github.com/nccgroup/sobelow) - static application security testing (SAST)

If I were configuring a CI/CD pipeline for this application, I would add steps to run these tools and fail the build if any issues were identified.

If I were creating a reusable application or library, I would also include [ExDoc](https://github.com/elixir-lang/ex_doc) for generating an HTML version of the documentation.