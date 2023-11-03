# Time Manager - Api

## Overview

Piscine Msc1 project, Creation of a TimeManager application.

- Context: 
    - There are rising tensions in the corridors of Gotham's town hall due to challenging working conditions, long shifts, and other issues. The main trade union (CGT-U) is alerting the authorities.
- Objective: 
    - To ease the tensions, the town hall decides to implement a time management application that the developers need to create. This application would allow municipal employees to access days off for recuperation.
- Description:
    - The Time Manager project is a web application that helps users manage their time efficiently. It consists of three main services:
        1. **Frontend**: The application's user interface.
        2. **API**: The backend that processes requests and interacts with the database.
        3. **Database**: Stores all the data required by the application.

    - Each of these services is containerized using Docker and orchestrated with Docker Compose for easy deployment and management.

## Table of Content

- [Routes](#routes)
  - [Authentication](#authentication)
  - [User](#user-protected)
  - [WorkingTime](#working-times-protected)
  - [Clock](#clocks-protected)
- [Installation & Start Up](#installation--start-up)
- [Learn More](#learn-more)

## Routes

- All the routes, except for `/login` and `/register`, are **protected** and require a valid **JWT token**.
- [Authentication](#authentication)
- [User](#user-protected)
- [WorkingTime](#working-times-protected)
- [Clock](#clocks-protected)

### Authentication
- **POST /login**: Authenticates a user and returns a JWT token.
  Request body should be in the following format:
  ```json
  {
    "user": {
      "email": "exemple@exemple.com",
      "password": "exemple123"
    }
  }
  ```
- **POST /register**: Registers a new user.
  Request body should be in the following format:
  ```json
  {
    "user": {
      "username": "exemple",
      "email": "exemple@exemple.com",
      "password": "exemple123",
    }
  }
  ```

### User (Protected)
- **GET /api/users**: Retrieves a list of users based on optional email and username filters.
- **GET /api/users/:userID**: Retrieves the details of a specific user by their ID.
- **POST /api/users**: Creates a new user.  
  Request body should be in the following format:
  ```json
  {
    "user": {
      "username": "exampleUsername",
      "email": "example@email.com"
    }
  }
  ```
- **PUT /api/users/:userID**: Updates the details of a specific user by their ID.
Request body should be in the following format:
  ```json
  {
    "user": {
      "username": "exampleUsername",
      "email": "example@email.com",
      "password": "example123"
    }
  }
  ```
- **DELETE /api/users/:userID**: Deletes a specific user by their ID.

### Working Times (Protected)
- **GET /api/workingtimes/:userID**: Retrieves all working time entries for a specific user within an optional date range.
- **GET /api/workingtimes/:userID/:id**: Retrieves a specific working time entry by its ID for a specific user.
- **POST /api/workingtimes/:userID**: Creates a new working time entry for a specific user.  
  Request body should be in the following format:
  ```json
  {
      "working_time": {
          "start": "2023-07-01 12:12:12",
          "end": "2023-07-12 19:12:12"
      } 
  }
  ```
- **PUT /api/workingtimes/:id**: Updates a specific working time entry by its ID.
Request body should be in the following format:
  ```json
  {
      "working_time": {
          "start": "2023-07-01 12:12:12",
          "end": "2023-07-12 19:12:12"
      } 
  }
  ```
- **DELETE /api/workingtimes/:id**: Deletes a specific working time entry by its ID.

### Clocks (Protected)
- **GET /api/clocks/:userID**: Retrieves all clocking events for a specific user.
- **POST /api/clocks/:userID**: Creates a new clocking event for a specific user.  
  Request body should be in the following format:
  ```json
  {
    "clock": {
      "time": "2023-01-01T12:00:00",
      "status": true
    }
  }
  ```

## Installation & Start Up

1. Install dependencies with:
```sh
mix deps.get
```
2. Create and migrate your database with`:
 ```sh
 mix ecto.setup
 ```
3. Start Phoenix endpoint with:
```sh
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: [https://www.phoenixframework.org/](https://www.phoenixframework.org/)
- Guides: [https://hexdocs.pm/phoenix/overview.html](https://hexdocs.pm/phoenix/overview.html)
- Docs: [https://hexdocs.pm/phoenix](https://hexdocs.pm/phoenix)
- Forum: [https://elixirforum.com/c/phoenix-forum](https://elixirforum.com/c/phoenix-forum)
- Source: [https://github.com/phoenixframework/phoenix](https://github.com/phoenixframework/phoenix)