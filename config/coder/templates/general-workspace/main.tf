terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.12"
    }
  }
}

variable "username" {
  description = "Username for the workspace"
  type        = string
}

variable "project_name" {
  description = "Name of your project"
  type        = string
  default     = "my-project"
}

variable "workspace_dir" {
  description = "Base directory for workspaces"
  type        = string
  default     = "${HOME}/Workspaces"
}

locals {
  workspace_path = "${var.workspace_dir}/${var.username}/${var.project_name}"
}

resource "coder_agent" "main" {
  os             = "darwin"
  arch           = "amd64"
  dir            = local.workspace_path
  startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Set up project directory
    mkdir -p ${local.workspace_path}
    cd ${local.workspace_path}
    
    # Initialize Git if not already initialized
    if [ ! -d .git ]; then
      git init
      git config user.name "${var.username}"
      git config user.email "${var.username}@localhost"
    fi
    
    # Create default .gitignore
    if [ ! -f .gitignore ]; then
      cat > .gitignore <<EOF
# macOS
.DS_Store
.AppleDouble
.LSOverride

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Dependencies
node_modules/
venv/
.env

# Build outputs
dist/
build/
*.pyc
__pycache__/
EOF
    fi
    
    echo "Workspace ready at: ${local.workspace_path}"
  EOT
}

resource "coder_metadata" "workspace_info" {
  resource_id = coder_agent.main.id
  item {
    key   = "Project"
    value = var.project_name
  }
  item {
    key   = "Path"
    value = local.workspace_path
  }
}

resource "coder_app" "vscode" {
  agent_id     = coder_agent.main.id
  slug         = "vscode"
  display_name = "VSCode"
  icon         = "/icon/code.svg"
  command      = "code ${local.workspace_path}"
}

resource "coder_app" "terminal" {
  agent_id     = coder_agent.main.id
  slug         = "terminal"
  display_name = "Terminal"
  icon         = "/icon/terminal.svg"
  command      = "open -a Terminal ${local.workspace_path}"
}

output "workspace_path" {
  value       = local.workspace_path
  description = "Path to the workspace directory"
}
