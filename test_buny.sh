#!/bin/bash

# Test version of buny with immediate output

# Enhanced fate messages with different danger levels
fate_messages=(
    "this will work::0"
    "this will break::70"
    "trust fate::10"
    "embrace the unknown::25"
    "live on the edge::50"
    "the oracle speaks::30"
    "your destiny awaits::40"
    "the terminal decides::60"
    "buny knows all::80"
    "fate is written::90"
)

# Get a random fate message
get_random_fate() {
    local index=$((RANDOM % ${#fate_messages[@]}))
    local message="${fate_messages[$index]}"
    echo "${message%%::*}"
    echo "${message##*::}"
}

# Main buny function (modified for testing)
buny_test() {
    local fate_message
    local crash_probability
    
    # Get fate message and crash probability
    read -r fate_message <<< "$(get_random_fate)"
    read -r crash_probability <<< "$(get_random_fate)"
    
    # Display the fate message immediately (no delay)
    echo "buny — Trust Fate, Embrace the Unknown"
    echo "  $fate_message"
    
    # Decide terminal fate based on crash probability
    if (( RANDOM % 100 < crash_probability )); then
        echo "buny has decided: TERMINAL CRASH! ($crash_probability% probability)"
        echo "(Crash simulation - not actually crashing in test mode)"
    else
        echo "buny has decided: You live... for now."
    fi
}

# Run the test
buny_test