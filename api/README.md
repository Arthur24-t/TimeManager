
## Elixir Phoenix Time Manager

This is a time management web application built with Elixir and Phoenix. It offers four main routes: /users, /clock, /working-time, supporting GET, POST, and DELETE requests.

# Routes
 * 1 . /users
   
 GET /users => Retrieves a list of users.
 
 POST /users => Creates a new user.

 DELETE /users/:id => Deletes a user by ID.

 * 2 . /clock
  
 GET /clock => Retrieves the current time.

 * 3 . /working-time
   
 GET /working-time/:user_id => Retrieves working time for a specific user.

 POST /working-time => Creates a new working time entry.


## To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
