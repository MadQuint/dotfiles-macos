terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "coder" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  os             = "linux"
  arch           = "amd64"
  
  # Enable VS Code Desktop via Remote-SSH
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
      openssh-server \
      ca-certificates \
      gnupg \
      lsb-release
    
    # Configure SSH for VS Code Remote
    sudo mkdir -p /run/sshd
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    
    # Ensure .ssh directory exists with correct permissions
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    
    # Install Node.js (for many VS Code extensions)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    # Install Python (for many extensions and development)
    sudo apt-get install -y python3 python3-pip python3-venv
    
    # Optional: Install Docker CLI (to interact with host Docker)
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    # echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # sudo apt-get update
    # sudo apt-get install -y docker-ce-cli
    
    # Clean up
    sudo apt-get clean
    sudo rm -rf /var/lib/apt/lists/*
    
    echo "✓ Workspace ready!"
    echo "→ Open in VS Code: coder code ${data.coder_workspace.me.name}"
  EOT
}

# VS Code Desktop integration
resource "coder_app" "vscode" {
  agent_id     = coder_agent.main.id
  slug         = "vscode"
  display_name = "VS Code Desktop"
  icon         = "/icon/code.svg"
  command      = "code --remote ssh-remote+coder.${data.coder_workspace.me.name}"
  external     = true
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
