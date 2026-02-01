terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.12"
    }
  }
}

# Admin parameters
variable "username" {
  description = "Username for the workspace"
  type        = string
}

# User parameters
variable "project_name" {
  description = "Name of your project"
  type        = string
  default     = "my-project"
}

variable "java_version" {
  description = "Java version to use"
  type        = string
  default     = "21"
  validation {
    condition     = contains(["11", "17", "21"], var.java_version)
    error_message = "Java version must be 11, 17, or 21"
  }
}

variable "workspace_dir" {
  description = "Base directory for workspaces"
  type        = string
  default     = "${HOME}/Workspaces"
}

locals {
  workspace_path = "${var.workspace_dir}/${var.username}/${var.project_name}"
}

# Workspace resource
resource "coder_agent" "main" {
  os             = "darwin"
  arch           = "amd64"
  dir            = local.workspace_path
  startup_script = <<-EOT
    #!/bin/bash
    set -e
    
    # Ensure Java is available
    if ! command -v java &> /dev/null; then
      echo "Java not found. Installing via Homebrew..."
      brew install openjdk@${var.java_version}
    fi
    
    # Set up project directory
    mkdir -p ${local.workspace_path}
    cd ${local.workspace_path}
    
    # Initialize Git if not already initialized
    if [ ! -d .git ]; then
      git init
      git config user.name "${var.username}"
      git config user.email "${var.username}@localhost"
    fi
    
    # Create default .gitignore for Java projects
    if [ ! -f .gitignore ]; then
      cat > .gitignore <<EOF
# IntelliJ IDEA
.idea/
*.iml
*.iws
out/
.idea_modules/

# Build outputs
target/
build/
*.class
*.jar
*.war

# Gradle
.gradle/
gradle-app.setting

# Maven
.mvn/
mvnw
mvnw.cmd

# macOS
.DS_Store
EOF
    fi
    
    echo "Workspace ready at: ${local.workspace_path}"
  EOT
}

# Metadata for workspace
resource "coder_metadata" "workspace_info" {
  resource_id = coder_agent.main.id
  item {
    key   = "Java Version"
    value = var.java_version
  }
  item {
    key   = "Project"
    value = var.project_name
  }
  item {
    key   = "Path"
    value = local.workspace_path
  }
}

# IntelliJ IDEA app
resource "coder_app" "intellij" {
  agent_id     = coder_agent.main.id
  slug         = "intellij"
  display_name = "IntelliJ IDEA"
  icon         = "/icon/intellij.svg"
  command      = "open -a 'IntelliJ IDEA' ${local.workspace_path}"
  
  health_check {
    url       = "http://localhost:63342"
    interval  = 10
    threshold = 60
  }
}

# VSCode app (alternative)
resource "coder_app" "vscode" {
  agent_id     = coder_agent.main.id
  slug         = "vscode"
  display_name = "VSCode"
  icon         = "/icon/code.svg"
  command      = "code ${local.workspace_path}"
}

# Terminal access
resource "coder_app" "terminal" {
  agent_id     = coder_agent.main.id
  slug         = "terminal"
  display_name = "Terminal"
  icon         = "/icon/terminal.svg"
  command      = "open -a Terminal ${local.workspace_path}"
}

# Output information
output "workspace_path" {
  value       = local.workspace_path
  description = "Path to the workspace directory"
}
