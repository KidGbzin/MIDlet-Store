# Supabase Development Guide

This document describes the procedures to run Supabase locally, apply migrations, and follow the function creation standards to ensure consistency and safety in the development environment.

## Requirements

To run Supabase locally and manage your database workflow, make sure the following tools are installed on your system:

- ### [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/)

    Supabase runs locally using Docker containers. These are required to spin up the database, authentication server, and other core services in an isolated and reproducible environment.

- ### [Supabase CLI](https://supabase.com/docs/guides/cli)

    The CLI (`supabase`) is used to start the local environment, apply database migrations, run SQL commands, and interact with your local project.

## Running Supabase Locally

Make sure your Docker daemon is running before executing the commands below, as Supabase uses Docker containers to run locally.

```bash
# Start the local Supabase environment.
supabase start
```

```bash
# Stop the local Supabase environment.
supabase stop
```

## Migrations Structure

Organize your migrations inside the `supabase/migrations/` directory using the following pattern:

```
ROOT/supabase/migrations/
├── 20250101000000_description.sql
├── 20250101000001_description.sql
└── ...
```

Each migration filename must begin with a leading timestamp in the format `YYYYMMDDHHMMSS`. This timestamp is required by Supabase to ensure migrations are applied in the correct chronological order and to prevent conflicts.

## Applying Migrations

To apply the migrations to your local database you can use the following command:

```bash
# Clears and reapplies all migrations.
supabase db reset     
```

**Important:** Never apply migrations manually (`supabase db push`) on remote staging or production databases. Migration deployment to these environments is automated via GitHub Actions workflows configured in the repository. This automation ensures consistent, synchronized schema changes and reduces the risk of human error during deployment.

## Database Standards

To ensure consistency and maintainability across the project, all SQL files must follow a clear set of conventions. These standards help organize the database logic and make the codebase easier to read, review, and evolve over time.

To ensure a consistent, readable, and scalable Supabase backend, follow these general project-wide guidelines:

- ### Use `snake_case` for all naming

    Supabase functions and database objects natively follow the `snake_case` convention. Mixing styles leads to inconsistent scripts, reduced readability, and lower code quality. This convention should be applied to function names, parameters, table names, column names, and migration filenames, as it aligns with PostgreSQL standards and improves overall clarity.

    ```sql
    -- Good!
    create or replace function example_function (parameter integer)...
    ```

    ```sql
    -- Bad!
    CREATE OR REPLACE FUNCTION EXAMPLE_FUNCTION (PARAMETER INTEGER)...
    ```

- ### Use `create table if not exists` for table definitions

    When defining tables, always use create table if not exists to prevent errors during local development or when reapplying migrations. This ensures that re-running the same migration or initializing the project in different environments doesn’t cause conflicts if the table already exists.

    ```sql
    -- Good!
    create table if not exists example ()...
    ```

    ```sql
    -- Bad!
    create table example ()...
    ```

- ### Use `create or replace` for functions

    Always use create or replace when defining SQL functions. This allows redefinition without needing to manually drop the function first, avoiding deployment errors and supporting smooth development workflows.

    ```sql
    -- Good!
    create or replace function example ()...
    ```

    ```sql
    -- Bad!
    create function example ()...
    ```

- ### Prefix function parameters with `p_`
    
    All input parameters in SQL or PL/pgSQL functions must be prefixed with `p_`. This makes it easy to distinguish between parameters, column names, and local variables — especially in complex queries or when writing joins, updates, or conditionals.

    This convention improves code clarity and avoids ambiguous references, particularly when parameter names match column names.

    ```sql
    -- Good!
    create or replace function get_object_by_identifier(p_identifier uuid) returns table (...) as $$
    begin
      return query
      select * from objects where key = p_identifier;
    end;
    $$ language plpgsql;
    ```

    ```sql
    -- Bad!
    create or replace function get_object_by_identifier(identifier uuid) returns table (...) as $$
    begin
      return query
      select * from objects where key = identifier;
    end;
    $$ language plpgsql;
    ```

- ### Function naming conventions

    When naming functions, use consistent prefixes to clearly communicate the function’s purpose and improve organization. Supabase RPC functions are listed alphabetically in both the Studio and your application’s repository — this convention makes it much easier to locate and understand each function.

    ```sql
    -- Use the prefix "count" for functions that return totals or grouped counts.
    create or replace function count_object ()...
    ```

    ```sql
    -- Use the prefix "delete" for functions that remove data.
    create or replace function delete_object ()...
    ```
    
    ```sql
    -- Use the prefix "get" for functions that retrieve data.
    create or replace function get_object ()...
    ```
    
    ```sql
    -- Use the prefix "increment" for functions that increase numeric values.
    create or replace function increment_object ()...
    ```
    
    ```sql
    -- Use the prefix "upsert" for functions that insert or update data.
    create or replace function upsert_object ()...
    ```

    When there are multiple similar functions with small variations, use the `with_` suffix to differentiate them. This keeps related functions grouped together alphabetically and helps clarify their specific use cases at a glance.

    ```sql
    -- A function that retrieves an object using an integer parameter.
    create or replace function get_object_with_integer (p_integer INTEGER)...
    ```

    ```sql
    -- A function that retrieves an object using a text parameter.
    create or replace function get_object_with_string (p_string TEXT)...
    ```

- ### Always set `search_path = public`

    Setting search_path explicitly to public ensures that all database operations are executed within the intended schema. This practice prevents unexpected behavior or security vulnerabilities caused by mutable or ambiguous search paths. Supabase’s database advisor highlights this as an important security measure, which you can read about in detail [here](https://supabase.com/docs/guides/database/database-advisors?queryGroups=lint&lint=0011_function_search_path_mutable).

    ```sql
    -- Good!
    create function example_function()
      returns void
      language sql
      set search_path = public
    as $$
      ...
    $$;
    ```

    ```sql
    -- Security risk!
    create function example_function()
      returns void
      language sql
    as $$
      ...
    $$;
    ```
- ### Include a clear return type

    Always specify the return type of your functions explicitly, using `returns table(...)`, `returns integer`, or the type that best fits the use case. Defining clear return types improves the usability of the API, enables better autocompletion and validation in clients, and makes the function’s output easier to understand, maintain, and test.

    ```sql
    -- Good!
    returns table (
        object_key uuid,
        object_description text
    )
    ```

    ```sql
    -- Bad, returns generic "record" type without specifying columns.
    returns record
    ```

- ### Always include in-code documentation
    
    Always document what the function does and why certain logic or calculations are used. This is especially important for complex queries, joins, or formulas involving weighted scores or business rules. Good documentation helps future maintainers understand the purpose and rationale behind the code, making debugging and enhancements easier.

    ```sql
    /*
        Returns a set of records applying custom business logic and ranking criteria.
        Adjusts scores to balance relevance and reliability.
    */
    ```

## Testing Functions Using Supabase Studio

You can test your SQL functions interactively using the Supabase Studio interface, which provides a built-in SQL editor.

- If you are running Supabase locally, you can open the Studio by navigating to:

    ```bash
    # The port shown when you run `supabase start`.
    http://localhost:PORT/
    ```
    
- If you are using a remote Supabase project, access Studio via:

    ```bash
    # Replace with your actual project ID.
    https://supabase.com/dashboard/project/PROJECT_ID/
    ```

Using Studio locally or remotely allows fast testing and debugging of database functions without extra tools or setup.

## Questions or Suggestions?

Open an [issue](https://github.com/KidGbzin/MIDlet-Store/issues) or submit a [pull request](https://github.com/KidGbzin/MIDlet-Store/pulls) with suggestions for this guide.