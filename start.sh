#!/bin/bash

# Configure Keycloak in a Fly.io friendly fashion.
#export JAVA_OPTS_APPEND="-Djava.net.preferIPv4Stack=false -Djava.net.preferIPv6Addresses=true"

# Database config
export KC_DB=postgres

## Regular expression to extract username, password and database
regex="postgres://([^:]+):([^@]+)@([^/]+)/([^?]+)"

if [[ $DATABASE_URL =~ $regex ]]; then
    user="${BASH_REMATCH[1]}"
    password="${BASH_REMATCH[2]}"
    server="${BASH_REMATCH[3]}"
    database="${BASH_REMATCH[4]}"

    export KC_DB_USERNAME="${user}"
    export KC_DB_PASSWORD="${password}"
    export KC_DB_URL="jdbc:postgresql://${server}/${database}?sslmode=disable"
else
    echo "Invalid DATABASE_URL format"
fi

# Various configurations
export KC_PROXY_HEADERS=xforwarded
export KC_HTTP_ENABLED=true
export KC_HOSTNAME_STRICT=false

# Base arguments for kc.sh start
args=(
  "--hostname=$PUBLIC_HOSTNAME"
)

# Append ADMIN_HOSTNAME if it is defined
if [ -n "$ADMIN_HOSTNAME" ]; then
  args+=( "--hostname-admin=$ADMIN_HOSTNAME" )
fi

# Append `--optimized if it is defined
if [ -n "$OPTIMIZED" ]; then
  args+=( "--optimized" )
else
    ADMIN_PASSWORD=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12; echo)
    export KC_BOOTSTRAP_ADMIN_USERNAME="temp-admin"
    export KC_BOOTSTRAP_ADMIN_PASSWORD="$ADMIN_PASSWORD"
    echo "Log in to admin using ${KC_BOOTSTRAP_ADMIN_USERNAME}:${KC_BOOTSTRAP_ADMIN_PASSWORD}"
fi

# Append any additional arguments passed to the script
args+=( "$@" )

/opt/keycloak/bin/kc.sh start "${args[@]}"
