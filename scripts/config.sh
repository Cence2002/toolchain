#!/usr/bin/env bash

GCP_PROJECT="projects-480019"
GCP_ZONE="europe-west1-b"

SSH_USER="${SSH_USER_OVERRIDE:-$(whoami)}"
SSH_KEY_PATH="${SSH_KEY_PATH_OVERRIDE:-$HOME/.ssh/id_ed25519.pub}"

PROJECTS_ROOT="${PROJECTS_ROOT_OVERRIDE:-$HOME/projects}"
