#!/bin/bash

# Args
WORKFLOW="$1"
CONFIG_NAME="$2"

# Logger function
source "./logger.sh"

# Check if WORKFLOW is provided
if [ -z "$WORKFLOW" ]; then
    log "ERROR" "WORKFLOW is not specified. Please provide the workflow name."
    exit 1
fi

# Check if CONFIG_NAME is provided
if [ -z "$CONFIG_NAME" ]; then
    log "ERROR" "CONFIG_NAME is not specified. Please provide the configuration name."
    exit 1
fi

# Create .secrets file
doppler secrets download --no-file --format docker --config "$CONFIG_NAME" > ".secrets"

# Run the main command
doppler run -- act -W ".github/workflows/$WORKFLOW.yml" --secret-file ".secrets"

# Remove the .secrets file and check the result directly
if rm -f ".secrets"; then
    log "SUCCESS" "The .secrets file has been successfully removed."
else
    log "WARNING" "Failed to remove the .secrets file. Please delete it manually."
fi
