This is a test project for the Creative Tech School.

The subject is to write a little CRUD app, using the techs of our choice.

I used [Elixir language](https://elixir-lang.org/), with the [Ash
framework](https://ash-hq.org/) to accomplish it.

Then, I deployed the project through [Fly.io](https://fly.io/).

## Online access

You can access and play with the deployed version here:
[https://creative.fly.dev](https://creative.fly.dev)

## Run the project locally

You can easily run the project locally.

### The easiest way: through a dev environment

Compatible systems:

* Linux
* MacOS
* Windows through the Windows Subsystem for Linux 2 (WSL2)

**4 easy steps:**

1. install Nix in your environment by running the following commmand (more doc
   [here](https://zero-to-nix.com/start/install) if you are curious about it):
    ```
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    ```

2. create a local folder where you want and clone this project's repository inside, with the command:
    ```
    git clone https://github.com/legrec14/creative-tech-school-test.git
    ```

3. still inside the project's folder, run the command:
    ```
    nix develop
    ```
    → this will fetch all project's direct dependencies, such as the right
    version of Elixir, the right version of PostgreSQL, etc… It will install all
    you need in the project's scope only.
4. still inside the project's folder, run the setup script, to download all dependencies and initialize the database:
    ```
    setup
    ```

### The longest way: install manually all needed tools on your machine

Compatible systems:

* Linux
* MacOS
* Windows (through WSL2 or not)

If you don’t want to go through the easiest way, you will need to manually install a few tools required by this project, unless you already have them installed.

**Here is the list of tools to install:**

* [Elixir](https://elixir-lang.org/install.html) (see the doc)
* [PostgreSQL](https://www.postgresql.org/download/) (see the doc)

**Then:**

1. create a local folder where you want and clone this project's repository inside, with the command:
    ```
    git clone https://github.com/legrec14/creative-tech-school-test.git
    ```
2. create a locale variable $PGDATA to store the database files:
    ```
    export PGDATA="$PWD/db"
    ```
2. still inside the project's folder, run the setup script, to download all dependencies and initialize the database:
    ```
    ./scripts/setup
    ```

## Testing the project

Tests has already been written.

You can see them inside the `/test` folder.

You can run them with the following command in your terminal, inside the project's folder:
```
mix test
```

## Starting the server locally

Phoenix provides a convenient way to start the server locally. You just have to
run the command:
```
mix phx.server
```
Then you can visit your localhost on port :4000 within your favorite web browser: [http://localhost:4000/](http://localhost:4000/)

## Playing with the project

Elixir provides an interractive shell.

You can launch an interractive shell within the compiled application by running
the following command in your terminal, inside the project's folder:
```
iex -S mix
```

### A few commands to play

Inside the Elixir interractive shell (after you launched `iex -S mix`), you can
run the following commands to play with the programm:

* ```elixir
  {:ok, contact} = Contact.create(%{first_name: "Toto"})
  ```
  → it will:
  * create a new `Contact` with the `first_name` attribute set to `"Toto"`
  * create a variable `contact` referrencing the created contact

* ```elixir
  Contact.get(contact.id)
  ```
  → it will show you the corresponding contact

* ```elixir
  Contact.list()
  ```
  → it will list all contacts

* ```elixir
  Contact.update(contact.id, %{birth_date: ~D[2000-01-01], phone: 00000000})
  ```
   → it will update the corresponding contact, and set the `birth_date` attribute
and the `phone` attribute with the given values

* ```elixir
  Contact.delete(contact.id)
  ```
  → it will delete the corresponding contact
