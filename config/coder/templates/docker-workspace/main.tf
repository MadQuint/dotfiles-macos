terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 1.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "coder" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  os             = "linux"
  arch           = "amd64"
  dir            = "/home/coder"
  
  startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Update package lists
    sudo apt-get update
    
    # Install essential development tools
    sudo apt-get install -y \
      git \
      curl \
      wget \
      vim \
      zsh \
      build-essential \
      ca-certificates \
      gnupg \
      lsb-release
    
    # Install Node.js (for VS Code extensions and development)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    # Install Python (for extensions and development)
    sudo apt-get install -y python3 python3-pip python3-venv
    
    # Clean up
    sudo apt-get clean
    sudo rm -rf /var/lib/apt/lists/*
    
    echo "✓ Workspace ready!"
    echo "→ Open in VS Code Desktop: coder code ${data.coder_workspace.me.name}"
    echo "→ Or access via browser: vscode.dev"
  EOT
}

# VS Code Desktop - Connect with local VS Code app via Coder extension
module "vscode_desktop" {
  source   = "registry.coder.com/modules/coder/vscode-desktop/coder"
  version  = "1.0.1"
  agent_id = coder_agent.main.id
  folder   = "/home/coder"
  order    = 1
}

# VS Code Server - Access via vscode.dev from any browser (iPad!)
# This enables full Microsoft extensions and Copilot in the browser
module "vscode_server" {
  source   = "registry.coder.com/modules/coder/vscode-server/coder"
  version  = "1.0.1"
  agent_id = coder_agent.main.id
  folder   = "/home/coder"
  order    = 2
}

resource "docker_container" "workspace" {
  image = "codercom/enterprise-base:ubuntu"
  name  = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  
  hostname = data.coder_workspace.me.name
  
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
  ]
  
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  
  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home.name
  }
}

resource "docker_volume" "home" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-home"
}

resource "coder_metadata" "container_info" {
  resource_id = docker_container.workspace.id
  
  item {
    key   = "image"
    value = docker_container.workspace.image
  }
  
  item {
    key   = "container_id"
    value = docker_container.workspace.id
  }
}
