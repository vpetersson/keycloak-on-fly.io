# keycloak on fly.io

This is an opinionated helper setup for running [Keycloak](https://www.keycloak.org/) on Fly.io.

Inspiration for settings are drawn from [this forum post](https://community.fly.io/t/run-keycloak-with-fly/5454/17).

## Usage

* Run `fly launch` from this directory
* Create a secret named `KC_HOSTNAME` for your app (e.g. `fly secrets set KC_HOSTNAME=http://auth.mydomain.com -a [app name]`)
* Create a CNAME matching `KC_HOSTNAME` (less the `https://` part of course)  that points to the URL you see after you deployed (e.g '[app name].fly.dev')
* Run `fly certs KC_HOSTNAME` to begin the TLS certificate process

## Development

There is a `docker-compose.yml` file to try to mock the behavior of Fly locally.
