# Workflow Project

This project provides scripts to manage Google Cloud VMs for development. It includes a Development Container to ensure a consistent environment across different host operating systems (Windows, macOS, Linux).

## Getting Started

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (running)
- [VS Code](https://code.visualstudio.com/) or [Cursor](https://cursor.sh/) with the **Dev Containers** extension installed ([ms-vscode-remote.remote-containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers))

### using the Dev Container

The Dev Container provides all necessary tools (`gcloud`, `git`, `ssh`) and mounts your local SSH directory so keys and configurations are shared.

1.  Open this folder in VS Code or Cursor.
2.  Click **Reopen in Container** when prompted (or run the command from the Command Palette: `Cmd+Shift+P` > `Dev Containers: Reopen in Container`).
3.  Once the container creates and connects, open a terminal.

### Setup

Run the setup script inside the container to configure your environment (GCloud auth, SSH config, etc.):

```bash
./scripts/setup-host.sh
```

**Note:** This script will:
- Authenticate with Google Cloud (follow the link in the terminal).
- Configure your `~/.ssh/config` to include VM configurations (this change is reflected on your host machine).
- Generate an SSH key if you don't have one.

### Managing VMs

Create a new VM:
```bash
./scripts/create-vm.sh [vm-name]
```

Delete a VM:
```bash
./scripts/delete-vm.sh [vm-name]
```

Sync projects on the VM:
```bash
./scripts/sync-projects.sh
```

## SSH Configuration & Mounts

The Dev Container is configured to bind-mount your local SSH directory (`~/.ssh`) to the container.
- **Source:** `${localEnv:HOME}/.ssh` (Your host machine's SSH folder)
- **Target:** `/home/bence/.ssh` (Container's SSH folder)

**What this means:**
- SSH keys generated inside the container are saved to your host.
- The `create-vm.sh` script creates VM-specific config files in `~/.ssh/vms/`.
- The `setup-host.sh` script adds `Include vms/*` to your main `~/.ssh/config`.
- You can SSH into your VMs directly from your host machine (e.g., `ssh [vm-name]`) without needing to be inside the container.

