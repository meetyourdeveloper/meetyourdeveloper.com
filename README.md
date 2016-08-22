# Meet Your Developer

Meet Your Developer is a _"stationary"_ site.

Source files from `lib/web/` are built into `docs/` and served either locally or on Github Pages.

## Installation

Clone this repo:

```shell
git clone https://github.com/meetyourdeveloper/meetyourdeveloper.com.git
cd meetyourdeveloper.com
```

Install the dependencies:

```shell
mix deps.get
mix compile
```

## Local Server

Starting the Elixir app will run a localhost server on port 7976: 

```shell
mix run --no-halt
```

Changes in `lib/web` will automatically be rebuilt.

## Publishing

Updating the `master` branch will update the live site.

For major changes, please _branch -> commit -> rebase -> review_ before updating `master`.
