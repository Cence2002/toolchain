#!/usr/bin/env bash

GCP_PROJECT="projects-480019"
GCP_ZONE="europe-west1-b"

USER="$(whoami)"
EMAIL="hervay.bence@gmail.com"

SSH_USER="${SSH_USER_OVERRIDE:-$(whoami)}"
SSH_KEY_PATH="${SSH_KEY_PATH_OVERRIDE:-$HOME/.ssh/id_ed25519.pub}"

PROJECTS_ROOT="$HOME/projects"
