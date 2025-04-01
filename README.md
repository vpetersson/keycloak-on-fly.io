# Keycloak on fly.io

**NOTE:** This was an expriment. I wouldn't recommend running Keycloak on Fly.io at the moment.

This is an opinionated helper setup for running [Keycloak](https://www.keycloak.org/) on Fly.io.

Inspiration for settings are drawn from [this forum post](https://community.fly.io/t/run-keycloak-with-fly/5454/17).

## Usage

* Run `fly launch --no-deploy` from this directory and make sure to answer `y` to `? Do you want to tweak these settings before proceeding? (y/N)` to launch the web configuration
  * Make sure to allocate 2GB of RAM
  * Under 'Postgres' select 'Fly Unmanaged Postgres'
* Create a secret named `PUBLIC_HOSTNAME` for your app (e.g. `fly secrets set PUBLIC_HOSTNAME=https://auth.mydomain.com`)
* Create a CNAME matching `PUBLIC_HOSTNAME` (less the `https://` part of course)  that points to the URL you see after you deployed (e.g '[app name].fly.dev')
* Run `fly certs add PUBLIC_HOSTNAME` to begin the TLS certificate process (again, leave out the `https://` part)
* Run `fly deploy --ha=false` to launch the application
* Run `fly logs` and look for the line `Log in to admin using [...]`, which will tell you the temporary admin credentials
* Enable the `--optimized` setting by setting `fly secrets set OPTIMIZED=true`
* Finally, move to HA mode by running `fly deploy --ha=true`

Note that the initial `boostrap-admin` command takes several minutes to load.

## Development

There is a `docker-compose.yml` file to try to mock the behavior of Fly locally.
