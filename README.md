# Campus Flow API

A RESTful API built with Ruby on Rails to manage campus students and teacher accounts with JWT authentication and role-based authorization.

## Features

- JWT authentication using Devise and Devise JWT
- Login and logout endpoints
- Role-based access control for admins and teachers
- Campus-level student data isolation
- Student CRUD operations
- Admin-only student deletion
- Admin-only teacher account creation
- Model validations and strong parameters
- Automated request tests using RSpec

## Tech Stack

- Ruby 3.4.10
- Ruby on Rails
- PostgreSQL
- Devise
- Devise JWT
- RSpec Rails
- FactoryBot

## Prerequisites

- Ruby and Bundler
- PostgreSQL
- Git

## Setup

Clone the repository and enter the project directory:

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd campus_flow_api
```

Install dependencies:

```bash
bundle install
```

Configure the PostgreSQL connection, then create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

Start the server:

```bash
bin/rails server
```

The default local server URL is `http://localhost:3000`.

## API Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/api/v1/login` | Log in |
| DELETE | `/api/v1/logout` | Log out |
| GET | `/api/v1/students` | List campus students |
| POST | `/api/v1/students` | Create a student |
| GET | `/api/v1/students/:id` | View a student |
| PATCH/PUT | `/api/v1/students/:id` | Update a student |
| DELETE | `/api/v1/students/:id` | Delete a student (admin only) |
| POST | `/api/v1/teachers` | Create a teacher (admin only) |

## Authentication

Log in using an existing account:

```json
{
  "user": {
    "email": "user@example.com",
    "password": "your_password"
  }
}
```

Send the JWT from the successful login response in the `Authorization` header for protected endpoints:

```text
Authorization: Bearer YOUR_JWT_TOKEN
```

Never publish real passwords, JWT tokens, or secret keys.

## Example: Create a Student

```json
{
  "student": {
    "name": "Arun Kumar",
    "email": "arun@example.com",
    "date_of_birth": "2005-06-15"
  }
}
```

Send this JSON body to `POST /api/v1/students` with a valid JWT.

## Running Tests

Run the full test suite:

```bash
bundle exec rspec
```

Latest verified result: **29 examples, 0 failures**.

## Security

- Keep credentials and secret keys out of version control.
- Use HTTPS in production.
- Enforce authorization on protected endpoints.
- Use safe environment configuration for secrets.

## Project Scope

This is an API-only project. Add separate frontend or Docker deployment instructions only after those components have been implemented and tested.
