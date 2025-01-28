#!/bin/bash

# =================================================================
# ping-domain.sh (ver. 1.0): Ping a domain, parse, write to CSV
# Pings a domain, parses the result and writes the result to a file
# =================================================================

main() {
    ARGS=2
    SCRIPT_NAME="${0}"
    SITE="${1}"
    TARGET="${2}"
    DATE_TIME=$(date | awk '{print $1, $2, $3, $4}')

    # if not 2 args, throw an error
    if [[ "$#" -ne ARGS ]]; then
        echo "Error: Usage: ping-domain.sh arg1 arg2"

        exit 1
    fi


    for item in "$@"; do
        if [[ -z "$item" ]]; then
        echo "Argument cannot be null!"
        exit 1
        fi

        # Check for disallowed characters
        if [[ ! "$item" =~ ^[a-zA-Z0-9_.]+$ ]]; then
        echo "Error: Argument '$item' contains invalid characters. \
        Only alphanumeric and underscores allowed"

        exit 1
        fi
    done


    echo "Pinging ${SITE}..."
    packet_loss=$(ping -4 -c 4 "${TARGET}" | grep "%"| awk '{print $6}')
    echo "Packet loss percentage is $packet_loss"

    # Check if the packet loss is 0%
    if [[ "$packet_loss" == "0%"  ]]; then
        echo "Ping successful: 0% packet loss"
    else
        echo "Ping failed: $packet_loss% packet loss"
    fi

    # Create or append to the CSV file
    csv_file="${SCRIPT_NAME%.*}.csv"
    echo "CSV file name is now: ${csv_file}"
    echo "${SCRIPT_NAME},${TARGET},${packet_loss},${DATE_TIME}" >> "$csv_file"
}

main "$@"
