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
  startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Install basic tools
    sudo apt-get update
    sudo apt-get install -y git curl wget vim zsh
    
    # Optional: Install dotfiles if you want
    # git clone https://github.com/yourusername/dotfiles-macos.git ~/dotfiles
    # cd ~/dotfiles && ./install
    
    echo "Workspace ready!"
  EOT
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
