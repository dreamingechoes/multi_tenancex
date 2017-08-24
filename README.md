# MultiTenancex

Example of Phoenix application with database multi tenancy.

## Setup development environment with Docker

This project is Docker friendly from day one. To start working on it:

* Setup the multi_tenancex container with `docker-compose build multi_tenancex`
* Install dependencies with `docker-compose run multi_tenancex mix deps.get`
* Create your database with `docker-compose run multi_tenancex mix ecto.create`
* Migrate your database with `docker-compose run multi_tenancex mix ecto.migrate`
* Install Node.js dependencies with `docker-compose run multi_tenancex bash -c "cd assets; npm install"`
* Start the application with `docker-compose up`

## Setup testing environment with Docker

This step assumes you already followed instructions from previous paragraph.

* Create your testing database with `docker-compose run multi_tenancex env MIX_ENV=test mix ecto.create`
* Migrate your testing database with `docker-compose run multi_tenancex env MIX_ENV=test mix ecto.migrate`
* Run the test suite with `mix test`
* Run the test suite with coverage report on `cover` folder with: `docker-compose run multi_tenancex env MIX_ENV=test mix coveralls.html`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

**MultiTenancex** is released under the [MIT License](http://www.opensource.org/licenses/MIT).
