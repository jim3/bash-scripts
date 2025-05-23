#!/bin/bash

# =================================================================
# ping-domain.sh (ver. 1.0)
# Pings a domain, parses and writes to CSV file
# =================================================================

main() {
    ARGS=2
    SCRIPT_NAME="${0}"
    SITE="${1}"
    TARGET="${2}"
    DATE_TIME=$(date | awk '{print $1, $2, $3, $4}')

    # check if the number of arguments is correct (2)
    if [[ "$#" -ne ARGS ]]; then
        echo "Error: Usage: ping-domain.sh arg1 arg2"
        exit 1
    fi
    # Check if given an empty string
    for item in "$@"; do
        if [[ -z "$item" ]]; then
        echo "Error: Argument '$item' is empty"
        exit 1
        fi       
        # Check for disallowed characters
        if [[ ! "$item" =~ ^[a-zA-Z0-9_.]+$ ]]; then
        echo "Error: Argument '$item' contains invalid characters. \
        Only alphanumeric and underscores allowed"
        exit 1
        fi
    done
    
    # Check if the packet loss is 0%
    echo "Pinging ${SITE}..."
    packet_loss=$(ping -4 -c 4 "${TARGET}" | grep "%"| awk '{print $6}')
    echo "Packet loss percentage is $packet_loss"
    if [[ "$packet_loss" == "0%"  ]]; then
        echo "Ping successful: 0% packet loss"
    else
        echo "Ping failed: $packet_loss% packet loss"
    fi

    # Write results to a CSV file
    csv_file="${SCRIPT_NAME%.*}.csv"
    echo "CSV file name is now: ${csv_file}"
    echo "${SCRIPT_NAME},${TARGET},${packet_loss},${DATE_TIME}" >> "$csv_file"
}

main "$@"
