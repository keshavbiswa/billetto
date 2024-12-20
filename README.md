# Billetto

This project is a Ruby on Rails application developed as part of a technical assessment for Billetto. The application fetches and displays events from the Billetto API, allows users to vote on events, and uses Clerk.com for user authentication.

## Table of Contents

*   [Features](#features)
*   [Gems Used](#gems-used)
*   [Services Integrated](#services-integrated)
*   [Domains](#domains)
*   [Setup Instructions](#setup-instructions)
*   [Testing](#testing)
*   [Approach and Design Choices](#approach-and-design-choices)

## Features

*   Fetches and displays events from the Billetto API. ( Currently, only rake task is provided)
*   Implements a voting system (upvote/downvote) for events.
*   Uses Rails Event Store to implement event sourcing for the voting functionality.
*   Integrates Clerk.com for user authentication (sign-up, login, logout).
*   Provides basic UI for event listing and voting.

## Gems Used

*   **`rails`:** The core Ruby on Rails framework.
*   **`pg`:** PostgreSQL adapter for Rails.
*   **`httparty`:** For making HTTP requests to the Billetto API.
*   **`dotenv-rails`:** For managing environment variables using a `.env` file.
*   **`counter_culture`:** To implement counter caching of votes.
*   **`clerk-sdk`:** Ruby SDK for integrating with Clerk.com authentication.
*   **`rails_event_store`:** For implementing event sourcing.
*   **`rspec-rails`:** For testing (development and test environment).
*   **`ruby_event_store-rspec`:** RSpec matchers for testing event publishing.

## Services Integrated

*   **Billetto API:** Used to fetch event data.
*   **Clerk.com:** Used for user authentication.

## Domains

The application uses a simplified domain-driven design approach with a single domain for `Voting`:

*   **`app/domain/voting`:** Contains the core business logic related to voting.
    *   **`commands`:**
        *   `create_vote_command.rb`: Represents the intent to create a vote.
    *   **`command_handlers`:**
        *   `vote_command_handler.rb`: Handles the `CreateVoteCommand`, creates/updates votes, and triggers event publishing.
    *   **`actions`:**
        *   `upvote_event.rb`: Publishes an `EventUpvoted` event.
        *   `downvote_event.rb`: Publishes an `EventDownvoted` event.
    *   **`events`:**
        *   `event_upvoted.rb`: Represents an upvote event.
        *   `event_downvoted.rb`: Represents a downvote event.

## Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Database setup:**

    ```bash
    rails db:create
    rails db:migrate
    ```

4.  **Environment variables:**

    Create a `.env` file in the root of the project and add the following environment variables:

    ```
    CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
    CLERK_SECRET_KEY=your_clerk_secret_key
    CLERK_SIGN_IN_URL=
    CLERK_SIGN_UP_URL=
    ```

    NOTE:- For billetto, we're using Rails credentials so you might need to update that as well.

    Replace the placeholders with your actual API keys and secrets.

5.  **Start the Rails server:**

    ```bash
    bin/dev
    ```

    The application should now be running at `http://localhost:3000`.

## Testing

*   **Run all tests:**

    ```bash
    bundle exec rspec
    ```
## Approach and Design Choices

The project is divided into different paradigms, an MVC structure to handle functional event listsings and Domain Driven Design (DDD) to handle voting system using Event Sourcing.

**Domain-Driven Design (DDD):** Core voting logic is encapsulated within the app/domain/voting directory, promoting modularity and maintainability.
**Command Query Responsibility Segregation (CQRS):** Voting::CreateVoteCommand, Voting::VoteCommandHandler, and Voting::UpvoteAction/Voting::DownvoteAction implement CQRS, separating command handling from event publishing for enhanced scalability. The Arkency::CommandBus facilitates this pattern by decoupling commands from their handlers.
**Service Objects:** A BillettoAPI service object abstracts interactions with the Billetto API, handling data fetching and response parsing.
Event Sourcing: Rails Event Store captures voting actions as events (EventUpvoted, EventDownvoted), providing an audit trail.
**Efficient Vote Counting:** ActiveRecord's counter_cache option is employed on the Vote model to efficiently maintain and update vote counts on associated events.
**Authentication:** Clerk.com is integrated to provide secure and user-friendly authentication.
