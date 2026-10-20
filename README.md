# Campus Flow API

A RESTful API built with Ruby on Rails to manage campus students and teacher accounts with JWT authentication and role-based authorization. This project demonstrates REST API development, authentication, authorization, database management, automated testing, and Docker containerization.

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
- Docker-based application and PostgreSQL setup

## Tech Stack

- Ruby 3.4.10
- Ruby on Rails
- PostgreSQL
- Devise
- Devise JWT
- RSpec Rails
- FactoryBot
- Docker
- Docker Compose

## Prerequisites

### For Local Setup

- Ruby and Bundler
- PostgreSQL
- Git

### For Docker Setup

- Docker
- Docker Compose

## Setup

### Option 1: Run Locally

Clone the repository and enter the project directory:

```bash
git clone https://github.com/ramya-murugan-s/campus_flow_api.git
cd campus_flow_api
```

Install dependencies:

```bash
bundle install
```

Configure the PostgreSQL connection and required Rails credentials for your local environment.

Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

Start the Rails server:

```bash
bin/rails server
```

The default local server URL is:

`http://localhost:3000`

### Option 2: Run Using Docker

Ensure Docker and Docker Compose are installed and running.

Configure the required environment variables in a local `.env` file. Set `POSTGRES_PASSWORD` and `RAILS_MASTER_KEY` with the appropriate values for your environment. Never commit `.env` or real secret values to Git.

Build the Docker image and start the application:

```bash
docker-compose up -d --build
```

Check the running containers:

```bash
docker-compose ps
```

View application logs:

```bash
docker-compose logs --tail=50 web
```

The application is available at:

`http://localhost:3000`

Stop the containers:

```bash
docker-compose down
```

The PostgreSQL data is stored in a Docker volume so that it can persist when containers are stopped and restarted.

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

Send this JSON body to `POST /api/v1/students` with a valid JWT:

```json
{
  "student": {
    "name": "Arun Kumar",
    "email": "arun@example.com",
    "date_of_birth": "2005-06-15"
  }
}
```

## Running Tests

### Run Tests Locally

Run the full test suite:

```bash
bundle exec rspec
```

### Run Tests Using Docker

Run the test suite inside Docker with the test environment enabled:

```bash
docker-compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

**Latest verified test result:** 29 examples, 0 failures.

## Security

- Keep credentials and secret keys out of version control.
- Store local secrets in `.env` and ensure the file is ignored by Git.
- Never commit `config/master.key` or expose production credentials.
- Use HTTPS in production.
- Enforce authorization on protected endpoints.
- Use appropriate environment configuration for secrets.

## Project Scope

This is an API-only project focused on backend development, JWT authentication, role-based authorization, PostgreSQL database integration, automated testing, and Docker-based development.

The project does not include a separate frontend application.