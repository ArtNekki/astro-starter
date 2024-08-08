#!/bin/bash

set -euo pipefail

# Logger function
source ./logger.sh

# Flag to track cleanup status
CLEANUP_IN_PROGRESS=false

# Function for cleanup and proper shutdown
cleanup() {
  if $CLEANUP_IN_PROGRESS; then
    log WARNING "Cleanup already in progress, please wait..."
    return
  fi
  CLEANUP_IN_PROGRESS=true

  # Ignore further SIGINT and SIGTERM
  trap '' SIGINT SIGTERM

  log WARNING "Stopping container $CONTAINER_NAME"
  docker container stop $CONTAINER_NAME || log WARN "Failed to stop container $CONTAINER_NAME"
  log SUCCESS "Container stopped"
}

# Set interrupt handler
trap cleanup SIGINT SIGTERM

# Main function
main() {
  log INFO "Script started"

  # Initialize variables with default values
  NODE_ENV=development
  DOCKERFILE=Dockerfile.dev
  PORT=4321:4321
  CONFIG_NAME=dev

  # Check if env parameter is provided
  case "${1:-}" in
  stage)
    NODE_ENV=staging
    DOCKERFILE=Dockerfile
    PORT=4321:80
    CONFIG_NAME=stage_docker
    ;;
  prod)
    NODE_ENV=production
    DOCKERFILE=Dockerfile
    PORT=4321:80
    CONFIG_NAME=prod_docker
    ;;
  *)
    NODE_ENV=development
    ;;
  esac

  log INFO "Environment set to $NODE_ENV"
  log INFO "Using port $PORT"

  # Load Doppler Secrets
  log INFO "Loading Doppler secrets for config $CONFIG_NAME"
  if ! eval "$(doppler secrets download --no-file --format docker --config "$CONFIG_NAME")"; then
    log ERROR "Failed to load Doppler secrets"
    exit 1
  fi

  # Build Docker image
  CONTAINER_NAME=$(doppler secrets get DOPPLER_PROJECT --plain --config "$1")-$NODE_ENV
  IMAGE_NAME="$(doppler secrets get DOCKER_USERNAME --plain --config "$1")/$CONTAINER_NAME:latest"

  if docker image inspect $IMAGE_NAME >/dev/null 2>&1; then
    log INFO "Docker image $IMAGE_NAME already exists. Skipping build."
  else
    log INFO "Building Docker image"
    if ! docker build -t $IMAGE_NAME \
      --build-arg DOPPLER_CONFIG=$DOPPLER_CONFIG \
      --build-arg STRAPI_URL=$STRAPI_URL \
      --build-arg NODE_ENV=$NODE_ENV \
      -f $DOCKERFILE .; then
      log ERROR "Docker build failed"
      exit 1
    fi
  fi

  # Run Docker container in background
  log INFO "Running Docker container in background"
  if ! docker run -d -p $PORT \
    -e DOPPLER_CONFIG=$DOPPLER_CONFIG \
    -e STRAPI_URL=$STRAPI_URL \
    -e NODE_ENV=$NODE_ENV \
    --rm --name $CONTAINER_NAME \
    $IMAGE_NAME; then
    log ERROR "Failed to start Docker container"
    exit 1
  fi

  # Extract the host port from the PORT variable
  HOST_PORT=$(echo $PORT | cut -d':' -f1)

  log SUCCESS "Container $CONTAINER_NAME is now running at http://localhost:$HOST_PORT"
  log INFO "Press Ctrl+C to stop the container and exit"

  # Wait for the container to stop or for a signal to be received
  while docker container inspect $CONTAINER_NAME >/dev/null 2>&1; do
    sleep 5
  done

  # If we get here, the container has stopped unexpectedly
  if ! $CLEANUP_IN_PROGRESS; then
    log ERROR "Container $CONTAINER_NAME has stopped unexpectedly"
    docker logs $CONTAINER_NAME
    exit 1
  fi
}

# Run main function
main "$@"

# Perform cleanup after main function exits
cleanup
