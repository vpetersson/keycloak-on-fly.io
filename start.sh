#!/bin/bash

# Configure Keycloak in a Fly.io friendly fashion.
export JAVA_OPTS_APPEND="-Djava.net.preferIPv4Stack=false"
#export JAVA_OPTS_KC_HEAP="-XX:MaxHeapFreeRatio=30 -XX:MaxRAMPercentage=65"

# Database config
export KC_DB=postgres

export KC_HOSTNAME_STRICT=false

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

/opt/keycloak/bin/kc.sh start \
    --http-enabled=true \
    --optimized \
    --hostname="$KC_HOSTNAME" \
    --proxy-headers xforwarded \
    "$@"
